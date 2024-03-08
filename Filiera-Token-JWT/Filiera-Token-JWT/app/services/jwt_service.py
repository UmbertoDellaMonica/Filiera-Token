import jwt

SECRET_KEY = 'filiera-token-blockchain'

from datetime import datetime, timedelta

# Dizionario per memorizzare le liste nere dei token per ogni ruolo
blacklist_tokens = {
    'MilkHub': set(),
    'CheeseProducer': set(),
    'Retailer': set(),
    'Consumer': set()
}


def generate_token(user):
    payload = {
        'exp': datetime.utcnow() + timedelta(minutes=15),  # Token scade dopo 15 minuti
        'iat': datetime.utcnow(),
        'user': user
    }
    token = jwt.encode(payload, SECRET_KEY, algorithm='HS256')

    # Aggiorna il token nell'oggetto utente
    user['token'] = token

    return token


def validate_token(token):
    print("Sono nell'invalidazione del Service ")
    try:
        # Decodifica il token per ottenere il ruolo dell'utente
        payload = jwt.decode(token, SECRET_KEY, algorithms=['HS256'])
        user_role = payload.get('user').get('user_type')

        # Controlla se il token è nella blacklist corrispondente al ruolo dell'utente
        if token in blacklist_tokens[user_role]:
            return False, None  # Token nella blacklist, non valido

        return True, payload  # Token valido, restituisce il payload
    except jwt.ExpiredSignatureError:
        return False, None
    except jwt.InvalidTokenError:
        return False, None


def invalidate_token(token, role):
    # Aggiunge il token alla lista nera
    blacklist_tokens[role].add(token)
