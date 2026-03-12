import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'table_selection_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isButlerSmiling = false;

  void _startJourney() {
    setState(() {
      _isButlerSmiling = true;
    });

    // Pequeno delay para mostrar o garçom sorrindo antes de navegar
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TableSelectionScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image (Parlor Interior)
          Positioned.fill(
            child: Image.asset(
              'images/chic_ice_cream_parlor_interior.png',
              fit: BoxFit.cover,
            ),
          ),

          // Linear Transparent Black Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 40),
                
                // Title
                Text(
                  'SORVETERIA',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 6,
                  ),
                ),
                Text(
                  'JENKINS',
                  style: GoogleFonts.parisienne(
                    color: Colors.pinkAccent,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Spacer(),

                // Butler Mascot
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Image.asset(
                    _isButlerSmiling 
                        ? 'images/Garcomsorrindo.png' 
                        : 'images/Garcomserio.png',
                    key: ValueKey<bool>(_isButlerSmiling),
                    height: 350,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 40),

                // Start Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: SizedBox(
                    width: double.infinity,
                    height: 65,
                    child: ElevatedButton(
                      onPressed: _startJourney,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35),
                        ),
                        elevation: 10,
                      ),
                      child: Text(
                        'COMEÇAR',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Social Media Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialIcon(Icons.camera_alt_outlined, 'Instagram'),
                    const SizedBox(width: 30),
                    _buildSocialIcon(Icons.close, 'X'), // Representando o X
                    const SizedBox(width: 30),
                    _buildSocialIcon(Icons.facebook_outlined, 'Facebook'),
                  ],
                ),
                
                const SizedBox(height: 10),
                Text(
                  'SIGA-NOS NAS REDES SOCIAIS',
                  style: GoogleFonts.outfit(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, String label) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 24),
        onPressed: () {
          // Ação para rede social (opcional)
        },
      ),
    );
  }
}
