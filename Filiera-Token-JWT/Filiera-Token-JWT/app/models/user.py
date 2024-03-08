class User:
    def __init__(self, email, password, wallet, user_type):
        self.email = email
        self.password = password
        self.wallet = wallet
        self.user_type = user_type

    def to_dict(self):
        return {
            'email': self.email,
            'password': self.password,  # Da non fare in pratica! Solo a scopo dimostrativo.
            'wallet': self.wallet,
            'user_type': self.user_type
        }
