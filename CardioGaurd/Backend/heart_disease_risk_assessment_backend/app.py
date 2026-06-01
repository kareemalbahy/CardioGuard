

from flask import Flask, request, jsonify
from flask_cors import CORS
import pandas as pd
import pickle
import numpy as np
import os

app = Flask(__name__)
CORS(app)  # Enable CORS for Flutter app

# Global variables for model and scaler
model = None
scaler = None
feature_names = None

# Feature columns
REQUIRED_FEATURES = [
    'age', 'sex', 'cp', 'trestbps', 'chol', 'fbs',
    'restecg', 'thalachh', 'exang', 'oldpeak',
    'slope', 'ca', 'thal']

def load_model_and_scaler():
    global model, scaler, feature_names

    try:
        # Load model
        model_path = 'xgboost_heart_disease_model.pkl'
        if not os.path.exists(model_path):
            raise FileNotFoundError(f"Model file not found: {model_path}")

        with open(model_path, 'rb') as f:
            model = pickle.load(f)
        print("✓ Model loaded successfully")

        # Load scaler
        scaler_path = 'scaler.pkl'
        if not os.path.exists(scaler_path):
            raise FileNotFoundError(f"Scaler file not found: {scaler_path}")

        with open(scaler_path, 'rb') as f:
            scaler = pickle.load(f)
        print("✓ Scaler loaded successfully")

        # Load feature names (optional)
        try:
            with open('feature_names.pkl', 'rb') as f:
                feature_names = pickle.load(f)
            print("✓ Feature names loaded successfully")
        except:
            feature_names = {'features': REQUIRED_FEATURES}
            print("⚠ Using default feature names")

        return True

    except Exception as e:
        #print(f" Error loading model/scaler: {str(e)}")
        print(e)  # ADD THIS
        return jsonify({
            'status': 'error',
            'message': str(e)
        }), 400

@app.route('/', methods=['GET'])
def home():
    """Health check endpoint"""
    return jsonify({
        'status': 'running',
        'message': 'Heart Disease Prediction API',
        'version': '2.0',
        'model_loaded': model is not None,
        'scaler_loaded': scaler is not None
    })

@app.route('/features', methods=['GET'])
def get_features():
    """Get required feature names"""
    return jsonify({
        'features': REQUIRED_FEATURES,
        'count': len(REQUIRED_FEATURES)
    })

@app.route('/predict', methods=['POST'])
def predict():
    """
    Prediction endpoint

    Expected input (JSON):
    {
        "age": 55,
        "sex": 1,
        "cp": 0,
        ... (all 13 features)
    }

    Or array of patients:
    [
        {"age": 55, ...},
        {"age": 62, ...}
    ]
    """
    # Check if model is loaded
    if model is None or scaler is None:
        return jsonify({
            'error': 'Model or scaler not loaded',
            'message': 'Server initialization failed'
        }), 500

    try:
        # Get JSON data
        data = request.get_json(force=True)

        if not data:
            return jsonify({
                'error': 'No data provided',
                'message': 'Please send patient data in JSON format'
            }), 400

        # Convert to DataFrame
        if isinstance(data, dict):
            df = pd.DataFrame([data])
        elif isinstance(data, list):
            df = pd.DataFrame(data)
        else:
            return jsonify({
                'error': 'Invalid data format',
                'message': 'Expected dict or list of dicts'
            }), 400

        # Check for missing features
        missing_features = [f for f in REQUIRED_FEATURES if f not in df.columns]
        if missing_features:
            return jsonify({
                'error': 'Missing required features',
                'missing': missing_features,
                'required': REQUIRED_FEATURES
            }), 400

        # Select and order features correctly
        df = df[REQUIRED_FEATURES]

        # Check for invalid values
        if df.isnull().any().any():
            return jsonify({
                'error': 'Invalid values detected',
                'message': 'All features must be numeric and non-null'
            }), 400

        # Scale the data
        df_scaled = scaler.transform(df)

        # Make predictions
        predictions = model.predict(df_scaled)
        probabilities = model.predict_proba(df_scaled)[:, 1]

        # Format results
        results = []
        for i in range(len(predictions)):
            results.append({
                'prediction': 'Disease' if predictions[i] == 1 else 'No Disease',
                'prediction_code': int(predictions[i]),
                'probability_disease': round(float(probabilities[i]), 2),
                'probability_no_disease': round(float(1 - probabilities[i]), 2),
                'confidence': round(float(max(probabilities[i], 1 - probabilities[i])), 2)
            })

        return jsonify({
            'success': True,
            'count': len(results),
            'predictions': results
        })

    except Exception as e:
        return jsonify({
            'error': 'Prediction failed',
            'message': str(e)
        }), 500

@app.errorhandler(404)
def not_found(e):
    return jsonify({
        'error': 'Endpoint not found',
        'available_endpoints': ['/', '/features', '/predict']
    }), 404

@app.errorhandler(500)
def internal_error(e):
    return jsonify({'error': 'Internal server error','message': str(e)}), 500

if __name__ == '__main__':
    # Load model and scaler
    if load_model_and_scaler():

        print(" Starting Flask API Server")

        print("Server: http://127.0.0.1:5000")
        print("Health check: http://127.0.0.1:5000/")
        print("Features: http://127.0.0.1:5000/features")
        print("Predict: http://127.0.0.1:5000/predict (POST)")

        print("  For production, use Gunicorn or uWSGI")


        # Run server
        app.run(debug=False, host='0.0.0.0', port=5000)
    else:
        print("\n Failed to start server - model/scaler not loaded")
        print("   Make sure these files exist:")
        print("   xgboost_heart_disease_model.pkl")
        print("   scaler.pkl")