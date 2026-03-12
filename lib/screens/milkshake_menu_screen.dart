import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import '../models/milkshake_model.dart';

class MilkshakeMenuScreen extends StatefulWidget {
  const MilkshakeMenuScreen({super.key});

  @override
  State<MilkshakeMenuScreen> createState() => _MilkshakeMenuScreenState();
}

class _MilkshakeMenuScreenState extends State<MilkshakeMenuScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.72);
  double _currentPage = 0.0;
  int _currentIndex = 0;
  double _dragOffset = 0.0;
  final Map<int, int> _cart = {}; // Rastreia as quantidades por índice
  int? _activeOrderNumber;
  String _orderStatus = 'Preparando seu pedido...';
  double _orderProgress = 0.3;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int totalItems = _cart.values.fold(0, (sum, item) => sum + item);

    return Scaffold(
      body: Stack(
        children: [
          // 1. Imagem de Fundo (Ambiente Chique)
          Positioned.fill(
            child: Image.asset(
              'images/chic_ice_cream_parlor_interior.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: milkshakes[_currentIndex].gradientColors,
                    ),
                  ),
                );
              },
            ),
          ),

          // 2. Overlay de Gradiente Transparente Dinâmico
          AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  milkshakes[_currentIndex].gradientColors[0].withOpacity(0.85),
                  milkshakes[_currentIndex].gradientColors[1].withOpacity(0.7),
                ],
              ),
            ),
          ),

          // 3. Widget de Destaque (Trapézio Chic 2.0)
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Center(child: _buildTrapezoidHighlight()),
          ),

          // Ícone do Carrinho no Topo
          Positioned(top: 50, right: 20, child: _buildCartBadge(totalItems)),

          // 3. Carrossel Central com PageView.builder
          Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _dragOffset += details.delta.dx;
                  });
                },
                onPanEnd: (details) {
                  setState(() {
                    _dragOffset = 0;
                  });
                },
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: milkshakes.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    double value = 1.0;
                    if (_pageController.position.haveDimensions) {
                      value = (_currentPage - index);
                      value = (1 - (value.abs() * 0.25)).clamp(0.0, 1.0);
                    } else {
                      value = index == 0 ? 1.0 : 0.75;
                    }

                    return AnimatedBuilder(
                      animation: _pageController,
                      builder: (context, child) {
                        double rotate = 0.0;
                        if (_pageController.position.haveDimensions) {
                          rotate = (_currentPage - index) * 0.1;
                        }

                        return Transform.scale(
                          scale: value,
                          child: Transform.rotate(angle: rotate, child: child),
                        );
                      },
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 100),
                            Image.asset(
                              milkshakes[index].image,
                              height: 300,
                              fit: BoxFit.contain,
                            ),
                            if (_activeOrderNumber != null) ...[
                              const SizedBox(height: 20),
                              _buildActiveOrderTracker(),
                            ],
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 20,
                              ), // Reduzi um pouco o padding
                              child: Column(
                                children: [
                                  Text(
                                    milkshakes[index].name.toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.outfit(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 32,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                    Text(
                                      milkshakes[index].description,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.outfit(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    _buildRoundedPriceButton(
                                      milkshakes[index].price,
                                    ),
                                  const SizedBox(height: 15),
                                  _buildBuyButton(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // Efeito visual da "Mão Puxando"
          if (_dragOffset.abs() > 20)
            Positioned(
              left: _dragOffset > 0 ? 30 : null,
              right: _dragOffset < 0 ? 30 : null,
              top: MediaQuery.of(context).size.height / 2 - 40,
              child: AnimatedOpacity(
                opacity: (_dragOffset.abs() / 150).clamp(0.0, 1.0),
                duration: const Duration(milliseconds: 100),
                child: Transform.translate(
                  offset: Offset(_dragOffset * 0.3, 0),
                  child: Column(
                    children: [
                      Icon(
                        _dragOffset > 0
                            ? Icons.swipe_right_rounded
                            : Icons.swipe_left_rounded,
                        color: Colors.white.withOpacity(0.8),
                        size: 70,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _dragOffset > 0
                            ? 'PUXE PARA DIREITA'
                            : 'PUXE PARA ESQUERDA',
                        style: GoogleFonts.outfit(
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCartBadge(int count) {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: const Icon(
            Icons.shopping_bag_outlined,
            color: Colors.white,
            size: 30,
          ),
          onPressed: count > 0 ? _showOrderSummary : null,
        ),
        if (count > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$count',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _showOrderSummary() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _OrderSummaryModal(
        cart: _cart,
        onClear: () {
          setState(() {
            _cart.clear();
            _activeOrderNumber = 1000 + Random().nextInt(9000);
            _orderStatus = 'Preparando seu pedido...';
            _orderProgress = 0.3;
          });
        },
      ),
    );
  }


  Widget _buildTrapezoidHighlight() {
    final bgColor = milkshakes[_currentIndex].gradientColors[1].withOpacity(
      0.9,
    );
    return ClipPath(
      clipper: const TrapezoidClipper(),
      child: Container(
        color: bgColor,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 25),
        child: Text(
          'Nosso cardápio',
          style: GoogleFonts.parisienne(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildRoundedPriceButton(String price) {
    return Container(
      width: 140,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.white.withOpacity(0.4), width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          'R\$ $price,00',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _updateQuantity(int index, int delta) {
    setState(() {
      final current = _cart[index] ?? 0;
      final newValue = current + delta;
      if (newValue <= 0) {
        _cart.remove(index);
      } else {
        _cart[index] = newValue;
      }
    });
  }

  Widget _buildBuyButton() {
    final qty = _cart[_currentIndex] ?? 0;
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: qty > 0 ? 240 : 230,
          height: 55,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: qty == 0
                ? InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () => _updateQuantity(_currentIndex, 1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.add_shopping_cart_rounded,
                          color: Colors.black,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'ADICIONAR AO PEDIDO',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                            color: Colors.black,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.remove_circle_outline,
                          color: Colors.black,
                        ),
                        onPressed: () => _updateQuantity(_currentIndex, -1),
                      ),
                      Text(
                        '$qty',
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.add_circle_outline,
                          color: Colors.black,
                        ),
                        onPressed: () => _updateQuantity(_currentIndex, 1),
                      ),
                    ],
                  ),
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: qty > 0
              ? Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Container(
                    width: 200,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.5),
                        width: 2,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(25),
                        onTap: _showOrderSummary,
                        child: Center(
                          child: Text(
                            'COMPRE AGORA',
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildActiveOrderTracker() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.timer_outlined,
                  color: Colors.greenAccent,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _orderStatus,
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Pedido #$_activeOrderNumber',
                      style: GoogleFonts.outfit(
                        color: Colors.white60,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Entregue',
                style: GoogleFonts.outfit(color: Colors.white38, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: LinearProgressIndicator(
              value: _orderProgress,
              backgroundColor: Colors.white10,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Colors.greenAccent,
              ),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTrackerButton(
                icon: Icons.chat_bubble_outline_rounded,
                label: 'Observação',
                onTap: () {},
              ),
              _buildTrackerButton(
                icon: Icons.star_outline_rounded,
                label: 'Avaliação',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrackerButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 18),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.outfit(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderSummaryModal extends StatefulWidget {
  final Map<int, int> cart;
  final VoidCallback onClear;

  const _OrderSummaryModal({required this.cart, required this.onClear});

  @override
  State<_OrderSummaryModal> createState() => _OrderSummaryModalState();
}

class _OrderSummaryModalState extends State<_OrderSummaryModal> {
  bool _showPaymentOptions = false;

  void _processCheckout() {
    setState(() {
      _showPaymentOptions = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      height:
          MediaQuery.of(context).size.height *
          (_showPaymentOptions ? 0.85 : 0.75),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Stack(
        children: [
          // Imagem do Jenkins no Fundo
          Positioned.fill(
            child: Opacity(
              opacity: 0.15,
              child: Image.asset(
                'images/Jenkins.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    const SizedBox.shrink(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Text(
                  _showPaymentOptions
                      ? 'FORMA DE PAGAMENTO'
                      : 'RESUMO DO PEDIDO',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                if (!_showPaymentOptions) ...[
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.cart.length,
                      itemBuilder: (context, index) {
                        int productIndex = widget.cart.keys.elementAt(index);
                        int quantity = widget.cart[productIndex]!;
                        var item = milkshakes[productIndex];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  item.image,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: GoogleFonts.outfit(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      'R\$ ${item.price},00 x $quantity',
                                      style: GoogleFonts.outfit(
                                        color: Colors.white60,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                'R\$ ${int.parse(item.price) * quantity},00',
                                style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    style: const TextStyle(color: Colors.white),
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: 'Alguma observação? (ex: sem canudo)',
                      hintStyle: const TextStyle(color: Colors.white38),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: _processCheckout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 10,
                      ),
                      child: Text(
                        'IR PARA PAGAMENTO',
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  // Opções de Pagamento
                  _buildPaymentOption(
                    title: 'PIX',
                    subtitle: 'Pagamento instantâneo',
                    icon: Icons.pix_rounded,
                    color: Colors.tealAccent,
                  ),
                  const SizedBox(height: 15),
                  _buildPaymentOption(
                    title: 'CARTÃO DE DÉBITO',
                    subtitle: 'Pagamento no local (Máquina TEF)',
                    icon: Icons.point_of_sale_rounded,
                    color: Colors.blueAccent,
                  ),
                  const SizedBox(height: 15),
                  _buildPaymentOption(
                    title: 'CARTÃO DE CRÉDITO',
                    subtitle: 'Pagamento no local (Máquina TEF)',
                    icon: Icons.point_of_sale_rounded,
                    color: Colors.orangeAccent,
                  ),
                  const Spacer(),
                  Text(
                    'Pagamento realizado no local da entrega ou retirada.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Pedido enviado para o Jenkins! 🚀'),
                            backgroundColor: Colors.pinkAccent,
                          ),
                        );
                        widget.onClear();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'CONFIRMAR E FINALIZAR',
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: TextButton(
                      onPressed: () =>
                          setState(() => _showPaymentOptions = false),
                      child: Text(
                        'VOLTAR AO RESUMO',
                        style: GoogleFonts.outfit(color: Colors.white70),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.outfit(
                    color: Colors.white60,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.radio_button_off_rounded, color: Colors.white24),
        ],
      ),
    );
  }
}

class TrapezoidClipper extends CustomClipper<Path> {
  const TrapezoidClipper();

  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width * 0.1, 0);
    path.lineTo(size.width * 0.9, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _StarEffect extends StatefulWidget {
  final Color color;
  const _StarEffect({required this.color});

  @override
  State<_StarEffect> createState() => _StarEffectState();
}

class _StarEffectState extends State<_StarEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _random = Random();
  final List<_StarParticle> _stars = [];

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..addListener(() {
            setState(() {
              for (var star in _stars) {
                star.update();
              }
              _stars.removeWhere((star) => star.opacity <= 0);
              if (_stars.length < 20) {
                _stars.add(_StarParticle(_random, widget.color));
              }
            });
          })
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(400, 400),
      painter: _StarPainter(_stars),
    );
  }
}

class _StarParticle {
  late Offset position;
  late double speed;
  late double angle;
  late double opacity;
  late double size;
  final Color color;

  _StarParticle(Random random, this.color) {
    position = Offset.zero;
    angle = random.nextDouble() * 2 * pi;
    speed = 0.5 + random.nextDouble() * 1.5;
    opacity = 1.0;
    size = 1.0 + random.nextDouble() * 2.5;
  }

  void update() {
    position += Offset(cos(angle) * speed, sin(angle) * speed);
    opacity -= 0.008;
    if (opacity < 0) opacity = 0;
  }
}

class _StarPainter extends CustomPainter {
  final List<_StarParticle> stars;
  _StarPainter(this.stars);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    for (var star in stars) {
      final paint = Paint()
        ..color = star.color.withOpacity(star.opacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

      canvas.drawCircle(star.position, star.size, paint);

      final starPaint = Paint()..color = Colors.white.withOpacity(star.opacity);
      canvas.drawCircle(star.position, star.size * 0.4, starPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
