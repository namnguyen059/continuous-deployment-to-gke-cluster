from flask import Flask, request, jsonify
import joblib

app = Flask(__name__)

model = joblib.load('model.joblib')

@app.route('/predict', methods=['POST'])
def predict():
    data = request.get_json(force=True)
    
    if 'features' not in data:
        return jsonify(error="Missing 'features' key in JSON payload"), 400
    
    try:
        prediction = model.predict([[data['features']['feature1'], data['features']['feature2']]])
        return jsonify(prediction=prediction[0])
    except Exception as e:
        return jsonify(error=str(e)), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
