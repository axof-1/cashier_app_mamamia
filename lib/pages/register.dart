import 'package:material_ui/material_ui.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  // 1. controller email dan password
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  // 2. dispose()

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Account Registration')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Silakan Daftar Akun Baru',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  'Silakan isi formulir di bawah ini untuk membuat akun baru',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Image.asset('assets/images/register.png', height: 180),
                const SizedBox(height: 24),
                // 3. TextFormField Email (+ validator)
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // 4. TextFormField Password (+ validator)
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    if (value.length < 6) {
                      return 'Password harus memiliki minimal 6 karakter';
                    }
                    return null;
                  },
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                // 5. ElevatedButton 'Daftar'
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Proses pendaftaran berhasil (2 detik menuju ke halaman login)'),
                          ),
                        );
                        await Future.delayed(const Duration(seconds: 2));
                        if (!context.mounted) return;
                        Navigator.pop(context); // Kembali ke halaman login
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: Colors.grey, width: 1),
                      ),
                    ),
                    child: const Text('Daftar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
