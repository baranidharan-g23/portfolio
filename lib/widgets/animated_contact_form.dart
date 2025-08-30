import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AnimatedFormField extends StatefulWidget {
  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final int maxLines;
  final bool isVisible;

  const AnimatedFormField({
    Key? key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.isVisible = false,
  }) : super(key: key);

  @override
  State<AnimatedFormField> createState() => _AnimatedFormFieldState();
}

class _AnimatedFormFieldState extends State<AnimatedFormField>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _focusController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  bool _hasError = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _focusController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _focusController,
      curve: Curves.easeOut,
    ));

    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
      
      if (_isFocused) {
        _focusController.forward();
      } else {
        _focusController.reverse();
        _validateField();
      }
    });
  }

  @override
  void didUpdateWidget(AnimatedFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      _slideController.forward();
    }
  }

  void _validateField() {
    if (widget.validator != null) {
      final error = widget.validator!(widget.controller.text);
      setState(() {
        _hasError = error != null;
        _errorText = error;
      });
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _focusController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.darkText,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: _isFocused 
                            ? AppTheme.primaryPurple.withOpacity(0.2)
                            : Colors.black.withOpacity(0.05),
                        blurRadius: _isFocused ? 12 : 6,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: widget.controller,
                    focusNode: _focusNode,
                    keyboardType: widget.keyboardType,
                    maxLines: widget.maxLines,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppTheme.darkText,
                    ),
                    decoration: InputDecoration(
                      hintText: widget.hint,
                      hintStyle: TextStyle(
                        color: AppTheme.lightText.withOpacity(0.6),
                      ),
                      prefixIcon: Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _isFocused
                                ? const Color(0xFF6366F1)
                                : const Color(0xFF9CA3AF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          widget.icon,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: _hasError 
                              ? Colors.red.withOpacity(0.3)
                              : Colors.grey.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppTheme.primaryPurple,
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),
                if (_hasError && _errorText != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 16),
                    child: Text(
                      _errorText!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
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

class SubmitButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isSuccess;
  final bool isError;

  const SubmitButton({
    Key? key,
    required this.onPressed,
    this.isLoading = false,
    this.isSuccess = false,
    this.isError = false,
  }) : super(key: key);

  @override
  State<SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton>
    with TickerProviderStateMixin {
  late AnimationController _buttonController;
  late AnimationController _successController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _successAnimation;

  @override
  void initState() {
    super.initState();
    
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    _successController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _buttonController,
      curve: Curves.easeOut,
    ));

    _successAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _successController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void didUpdateWidget(SubmitButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSuccess && !oldWidget.isSuccess) {
      _successController.forward();
    } else if (!widget.isSuccess) {
      _successController.reset();
    }
  }

  @override
  void dispose() {
    _buttonController.dispose();
    _successController.dispose();
    super.dispose();
  }

  Color _getButtonColor() {
    if (widget.isSuccess) return AppTheme.primaryGreen;
    if (widget.isError) return Colors.red;
    return AppTheme.primaryPurple;
  }

  Widget _getButtonChild() {
    if (widget.isLoading) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }
    
    if (widget.isSuccess) {
      return ScaleTransition(
        scale: _successAnimation,
        child: const Icon(
          Icons.check,
          color: Colors.white,
          size: 24,
        ),
      );
    }
    
    if (widget.isError) {
      return const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, color: Colors.white, size: 20),
          SizedBox(width: 8),
          Text(
            'Try Again',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }
    
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.send, color: Colors.white, size: 20),
        SizedBox(width: 8),
        Text(
          'Send Message',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _buttonController.forward(),
      onTapUp: (_) => _buttonController.reverse(),
      onTapCancel: () => _buttonController.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: _getButtonColor(),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: _getButtonColor().withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(28),
              onTap: widget.isLoading ? null : widget.onPressed,
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _getButtonChild(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
