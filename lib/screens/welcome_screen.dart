import 'package:flutter/material.dart';
import 'package:gharzo_project/screens/login/login_view.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print("✅ WelcomeScreen BUILD CALLED");

    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ================= BACKGROUND IMAGE =================
          SizedBox(
            height: size.height * 0.65,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  "https://images.unsplash.com/photo-1589129140837-67287c22521b?q=80&w=1965&auto=format&fit=crop",
                  fit: BoxFit.cover,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.25),
                        Colors.black.withOpacity(0.55),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ================= CONTENT =================
          SafeArea(
            child: Column(
              children: [
                const Spacer(),

                // LOGO + TITLE
                Column(
                  children: [
                    Container(
                      width: 66,
                      height: 66,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage("assets/logo/splash.jpeg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "GHARZO",
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Dream House",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // ================= CURVED WHITE PANEL =================
                Transform.translate(
                  offset: const Offset(0, -40), // 🔥 MAKES CURVE VISIBLE
                  child: ClipPath(
                    clipper: TopInverseCurveClipper(),
                    child: Container(
                      width: double.infinity,
                      height: size.height * 0.40,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 36,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 30,
                            offset: const Offset(0, -10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "WELCOME",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            "Find your next space, feel at home\nWhere comfort meets convenience",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 32),

                          // LOGIN
                          SizedBox(
                            width: size.width * 0.5,
                            height: 44,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => LoginView(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // SIGN UP
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ================= CLIPPER =================
class TopInverseCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(0, 70);

    // 🔥 INVERTED U (∩) — CLEARLY VISIBLE
    path.quadraticBezierTo(
      size.width / 2,
      -60, // curve goes UP into the image
      size.width,
      70,
    );

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
