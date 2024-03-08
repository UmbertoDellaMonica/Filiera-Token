import jwt
from flask import request, jsonify
from app import app
from app.services import jwt_service
from app.services.jwt_service import SECRET_KEY


@app.route('/generate-jwt-token', methods=['POST'])
def generate_jwt_token():
    # Effettua i controlli sui parametri in ingresso
    data = request.json
    required_fields = ['email', 'password', 'wallet', 'user_type']
    print(" Sono sul metodo di generate()")

    if not all(field in data for field in required_fields):
        return jsonify({'error': 'Missing one or more required fields'}), 400

    # Se tutti i campi richiesti sono presenti, procedi con la generazione del token
    user = {
        'email': data['email'],
        'wallet': data['wallet'],
        'user_type': data['user_type']
    }

    # Genera il token JWT
    token = jwt_service.generate_token(user)
    return jsonify({'token': token}), 200


@app.route('/protected', methods=['GET'])
def protected():
    # Controlla se il token è presente nell'header Authorization
    token = request.headers.get('Authorization')
    if not token:
        return jsonify({'error': 'Token missing'}), 401

    # Validazione del token
    valid, decoded_token = jwt_service.validate_token(token)
    if not valid:
        return jsonify({'error': 'Invalid token'}), 401

    # Utilizzo dei dati decodificati dal token
    user_data = decoded_token.get('user')
    return jsonify({'message': 'Access granted', 'user': user_data}), 200

@app.route('/invalidate-token', methods=['POST'])
def invalidate_token():
    # Controlla se il token è presente nella richiesta
    print("Sono nella route di Invalidate")
    data = request.json
    if 'token' not in data:
        return jsonify({'error': 'Token missing'}), 400

    # Ottieni il token dalla richiesta
    token = data['token']
    print("TOKEN: "+token)

    # Decodifica il token per ottenere il ruolo dell'utente
    payload = jwt.decode(token, SECRET_KEY, algorithms=['HS256'])
    user_role = payload.get('user').get('user_type')

    # Invalida il token
    jwt_service.invalidate_token(token,user_role)
    print("Ho invalidato il token!")

    return jsonify({'message': 'Token invalidated successfully'}), 200
