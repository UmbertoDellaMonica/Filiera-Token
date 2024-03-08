import 'package:filiera_token_front_end/components/atoms/custom_button.dart';
import 'package:filiera_token_front_end/models/User.dart';
import 'package:filiera_token_front_end/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class CustomViewProfile extends StatefulWidget {
  final User userData;

  CustomViewProfile({super.key, required this.userData});

  @override
  _CustomViewProfile createState() => _CustomViewProfile();
}

class _CustomViewProfile extends State<CustomViewProfile> {
  Image? _image = Image.asset('../assets/man.png');

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = Image.network(image.path);
      });
    }
  }

   Widget _buildInfoContainer(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(width: 16.0), // Adjust the spacing as needed
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16.0, color: Colors.white),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewProfile(User userDataStored) {
    String wallet = userDataStored.wallet;
    String balance = userDataStored.balance;
    String email = userDataStored.email;
    String password = userDataStored.password;
    String fullName = userDataStored.fullName;
    String actorType = Enums.getActorText(userDataStored.getType);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
                const Text(
                  "Dati Personali",
                  style: TextStyle(
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 16.0),
                GestureDetector(
                onTap: () => _pickImage(),
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 80.0,
                      backgroundImage: _image?.image,
                      backgroundColor: Colors.blue[200],
                    ),
                    const Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 20.0,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]
          ),
          const SizedBox(height: 10),
          _buildInfoContainer("Ruolo", actorType),
          const SizedBox(height: 10),
          _buildInfoContainer("Wallet", wallet),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildInfoContainer("Saldo", "$balance"+"FTL"),
              ),
              const SizedBox(width: 5),
              CustomButton(
                text: "Ricarica",
                type: CustomType.neutral,
                onPressed: () {
                  // TODO: Implementare la ricarica del conto
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildInfoContainer("E-Mail", email),
          const SizedBox(height: 10),
          _buildInfoContainer("Nome", fullName),
          const SizedBox(height: 10),
          _buildInfoContainer("Password", password),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return _buildViewProfile(widget.userData);
  }
}

