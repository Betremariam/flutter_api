import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Get(),
      title: "Quantum Post",
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Get extends StatefulWidget {
  const Get({super.key});

  @override
  State<Get> createState() => _GetState();
}

class _GetState extends State<Get> with SingleTickerProviderStateMixin {
  TextEditingController title = TextEditingController();
  TextEditingController body = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;
  bool _isLoading = false;
  bool _success = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _colorAnimation = ColorTween(
      begin: Colors.blueAccent,
      end: Colors.purpleAccent,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> Submit(String title, String body) async {
    setState(() {
      _isLoading = true;
      _success = false;
    });

    try {
      final response = await http.post(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
        body: json.encode({'title': title, 'body': body}),
        headers: {'Content-type': 'application/json'},
      );

      if (response.statusCode == 201) {
        setState(() {
          _success = true;
          _isLoading = false;
        });

        // Reset success state after 3 seconds
        Future.delayed(Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              _success = false;
            });
          }
        });
      } else {
        throw Exception("Error occurred");
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _success = false;
      });
      _showErrorDialog();
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.black.withOpacity(0.8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Colors.redAccent, width: 2),
            ),
            title: Text('Error', style: TextStyle(color: Colors.redAccent)),
            content: Text(
              'Failed to post. Please try again.',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK', style: TextStyle(color: Colors.blueAccent)),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated Background
          AnimatedBackground(),

          // Floating Particles
          ParticleField(),

          // Main Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with animated text
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(
                          0,
                          sin(_animationController.value * 2 * pi) * 5,
                        ),
                        child: Text(
                          "Quantum\nPost Creator",
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            foreground:
                                Paint()
                                  ..shader = LinearGradient(
                                    colors: [
                                      Colors.blueAccent,
                                      Colors.purpleAccent,
                                      Colors.pinkAccent,
                                    ],
                                  ).createShader(Rect.fromLTWH(0, 0, 300, 100)),
                            shadows: [
                              Shadow(
                                blurRadius: 10,
                                color: _colorAnimation.value!,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 40),

                  // Glass Morphism Card for Form
                  AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: BackdropFilter(
                      filter: ColorFilter.mode(
                        Colors.white.withOpacity(0.1),
                        BlendMode.overlay,
                      ),
                      child: Column(
                        children: [
                          // Title Input with Neon Effect
                          AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blueAccent.withOpacity(0.3),
                                      Colors.purpleAccent.withOpacity(0.3),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _colorAnimation.value!.withOpacity(
                                        0.5,
                                      ),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  controller: title,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: "Post Title",
                                    labelStyle: TextStyle(
                                      color: Colors.white70,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide.none,
                                    ),
                                    filled: true,
                                    fillColor: Colors.transparent,
                                    prefixIcon: Icon(
                                      Icons.title,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                          SizedBox(height: 20),

                          // Body Input with Holographic Effect
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.purpleAccent.withOpacity(0.3),
                                  Colors.pinkAccent.withOpacity(0.3),
                                ],
                              ),
                            ),
                            child: TextField(
                              controller: body,
                              maxLines: 4,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              decoration: InputDecoration(
                                labelText: "Post Content",
                                labelStyle: TextStyle(color: Colors.white70),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.transparent,
                                prefixIcon: Icon(
                                  Icons.description,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 30),

                          // Submit Button with Particle Effect
                          AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _scaleAnimation.value,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.blueAccent,
                                        Colors.purpleAccent,
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: _colorAnimation.value!
                                            .withOpacity(0.6),
                                        blurRadius: 15,
                                        spreadRadius: 3,
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(20),
                                      onTap:
                                          _isLoading
                                              ? null
                                              : () =>
                                                  Submit(title.text, body.text),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 15,
                                          horizontal: 40,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (_isLoading)
                                              SizedBox(
                                                height: 20,
                                                width: 20,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor:
                                                      AlwaysStoppedAnimation(
                                                        Colors.white,
                                                      ),
                                                ),
                                              )
                                            else
                                              Icon(
                                                Icons.rocket_launch,
                                                color: Colors.white,
                                              ),

                                            SizedBox(width: 10),
                                            Text(
                                              _isLoading
                                                  ? "TRANSMITTING..."
                                                  : "LAUNCH POST",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  Spacer(),

                  // Success Animation
                  if (_success)
                    Center(
                      child: Column(
                        children: [
                          LottieLikeAnimation(),
                          Text(
                            "POST LAUNCHED SUCCESSFULLY!",
                            style: TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  blurRadius: 10,
                                  color: Colors.greenAccent,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom animated background
class AnimatedBackground extends StatefulWidget {
  @override
  _AnimatedBackgroundState createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(
                _animation.value * 2 - 1,
                _animation.value * 2 - 1,
              ),
              radius: 1.5,
              colors: [
                Colors.purple.shade900.withOpacity(0.8),
                Colors.blue.shade900.withOpacity(0.8),
                Colors.black,
              ],
            ),
          ),
        );
      },
    );
  }
}

// Floating particles effect
class ParticleField extends StatefulWidget {
  @override
  _ParticleFieldState createState() => _ParticleFieldState();
}

class _ParticleFieldState extends State<ParticleField>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Particle> particles = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();

    // Initialize particles
    for (int i = 0; i < 20; i++) {
      particles.add(Particle());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlePainter(particles, _controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class Particle {
  double x = Random().nextDouble();
  double y = Random().nextDouble();
  double speed = Random().nextDouble() * 0.02;
  double size = Random().nextDouble() * 3 + 1;
  Color color = Colors.accents[Random().nextInt(Colors.accents.length)];
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double time;

  ParticlePainter(this.particles, this.time);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint =
          Paint()
            ..color = particle.color.withOpacity(0.6)
            ..style = PaintingStyle.fill;

      // Animate particle movement
      double x = (particle.x + time * particle.speed) % 1.0;
      double y = (particle.y + time * particle.speed * 0.5) % 1.0;

      canvas.drawCircle(
        Offset(x * size.width, y * size.height),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Simple lottie-like success animation
class LottieLikeAnimation extends StatefulWidget {
  @override
  _LottieLikeAnimationState createState() => _LottieLikeAnimationState();
}

class _LottieLikeAnimationState extends State<LottieLikeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _controller.value,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Colors.greenAccent, Colors.green],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.greenAccent.withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Icon(Icons.check, color: Colors.white, size: 40),
          ),
        );
      },
    );
  }
}
