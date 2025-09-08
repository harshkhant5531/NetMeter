// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../apiservice/apiService.dart';
//
// class FeedbackScreen extends StatefulWidget {
//   const FeedbackScreen({super.key});
//
//   @override
//   State<FeedbackScreen> createState() => _FeedbackScreenState();
// }
//
// class _FeedbackScreenState extends State<FeedbackScreen>
//     with TickerProviderStateMixin {
//   final _formKey = GlobalKey<FormState>();
//
//   // Controllers
//   final TextEditingController _nameCtrl = TextEditingController();
//   final TextEditingController _mobileCtrl = TextEditingController();
//   final TextEditingController _emailCtrl = TextEditingController();
//   final TextEditingController _messageCtrl = TextEditingController();
//   final TextEditingController _remarksCtrl = TextEditingController();
//
//   bool _isSubmitting = false;
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _nameCtrl.dispose();
//     _mobileCtrl.dispose();
//     _emailCtrl.dispose();
//     _messageCtrl.dispose();
//     _remarksCtrl.dispose();
//     super.dispose();
//   }
//
//   Future<void> _submitFeedback() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     setState(() => _isSubmitting = true);
//
//     bool success = await ApiService.postAppFeedback(
//       appName: "NetMeter",
//       versionNo: "1.0.0",
//       platform: "Android",
//       personName: _nameCtrl.text,
//       mobile: _mobileCtrl.text,
//       email: _emailCtrl.text,
//       message: _messageCtrl.text,
//       remarks: _remarksCtrl.text,
//     );
//
//     setState(() => _isSubmitting = false);
//
//     _showResultDialog(success);
//
//     if (success) {
//       _formKey.currentState!.reset();
//       _nameCtrl.clear();
//       _mobileCtrl.clear();
//       _emailCtrl.clear();
//       _messageCtrl.clear();
//       _remarksCtrl.clear();
//     }
//   }
//
//   void _clearForm() {
//     _formKey.currentState!.reset();
//     _nameCtrl.clear();
//     _mobileCtrl.clear();
//     _emailCtrl.clear();
//     _messageCtrl.clear();
//     _remarksCtrl.clear();
//   }
//
//   void _showResultDialog(bool success) {
//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         child: Container(
//           padding: const EdgeInsets.all(24),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             gradient: LinearGradient(
//               colors: success
//                   ? [const Color(0xFF4CAF50), const Color(0xFF8BC34A)]
//                   : [const Color(0xFFF44336), const Color(0xFFE57373)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.2),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(
//                   success ? Icons.check_circle : Icons.error,
//                   size: 48,
//                   color: Colors.white,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Text(
//                 success ? 'Success!' : 'Error!',
//                 style: GoogleFonts.poppins(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 success
//                     ? 'Your feedback has been submitted successfully!'
//                     : 'Failed to submit feedback. Please try again.',
//                 style: GoogleFonts.poppins(
//                   fontSize: 14,
//                   color: Colors.white.withOpacity(0.9),
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () => Navigator.pop(context),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.white,
//                   foregroundColor: success
//                       ? const Color(0xFF4CAF50)
//                       : const Color(0xFFF44336),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(25),
//                   ),
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 24,
//                     vertical: 12,
//                   ),
//                 ),
//                 child: Text(
//                   'OK',
//                   style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     TextInputType? keyboardType,
//     int maxLines = 1,
//     String? Function(String?)? validator,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: keyboardType,
//         maxLines: maxLines,
//         validator: validator,
//         style: GoogleFonts.poppins(
//           fontSize: 16,
//           color: const Color(0xFF374151),
//         ),
//         decoration: InputDecoration(
//           labelText: label,
//           labelStyle: GoogleFonts.poppins(
//             color: const Color(0xFF6B7280),
//             fontSize: 14,
//           ),
//           filled: true,
//           fillColor: const Color(0xFFF3F4F6),
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 16,
//             vertical: 16,
//           ),
//           // Default border (when not focused)
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: const BorderSide(color: Color(0xFFD1D5DB), width: 1),
//           ),
//           // When field is enabled but not focused
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: const BorderSide(color: Color(0xFFD1D5DB), width: 1),
//           ),
//           // When field is focused
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: const BorderSide(color: Color(0xFF3EADCF), width: 2),
//           ),
//           // When there's an error
//           errorBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: const BorderSide(color: Color(0xFFF44336), width: 1),
//           ),
//           // When field is focused and has error
//           focusedErrorBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: const BorderSide(color: Color(0xFFF44336), width: 2),
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF3F4F6),
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(100),
//         child: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Color(0xFF3EADCF), Color(0xFFABE9CD)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black26,
//                 blurRadius: 8,
//                 offset: Offset(0, 4),
//               ),
//             ],
//           ),
//           child: SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               child: Row(
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.arrow_back, color: Colors.white),
//                     onPressed: () => Navigator.pop(context),
//                   ),
//                   const SizedBox(width: 8),
//                   Text(
//                     'Feedback',
//                     style: GoogleFonts.poppins(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                       letterSpacing: 1.2,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       const SizedBox(height: 8),
//
//                       // Name Field
//                       _buildTextField(
//                         controller: _nameCtrl,
//                         label: "Name",
//                         validator: (value) =>
//                             value!.isEmpty ? "Please enter your name" : null,
//                       ),
//
//                       // Mobile Number Field
//                       _buildTextField(
//                         controller: _mobileCtrl,
//                         label: "Mobile Number",
//                         keyboardType: TextInputType.phone,
//                         validator: (value) => value!.isEmpty
//                             ? "Please enter your mobile number"
//                             : null,
//                       ),
//
//                       // Email Field
//                       _buildTextField(
//                         controller: _emailCtrl,
//                         label: "Email",
//                         keyboardType: TextInputType.emailAddress,
//                         validator: (value) =>
//                             value!.isEmpty || !value.contains("@")
//                             ? "Enter a valid email address"
//                             : null,
//                       ),
//
//                       // Feedback Field
//                       _buildTextField(
//                         controller: _messageCtrl,
//                         label: "Feedback",
//                         maxLines: 4,
//                         validator: (value) => value!.isEmpty
//                             ? "Please enter your feedback"
//                             : null,
//                       ),
//
//                       // Optional: Add remarks field if needed
//                       if (_remarksCtrl.text.isNotEmpty ||
//                           false) // You can control this visibility
//                         _buildTextField(
//                           controller: _remarksCtrl,
//                           label: "Additional Remarks",
//                           maxLines: 2,
//                         ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               // Bottom buttons
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Container(
//                         height: 50,
//                         margin: const EdgeInsets.only(right: 8),
//                         child: ElevatedButton(
//                           onPressed: _isSubmitting ? null : _submitFeedback,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF374151),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                           child: _isSubmitting
//                               ? const SizedBox(
//                                   width: 20,
//                                   height: 20,
//                                   child: CircularProgressIndicator(
//                                     strokeWidth: 2,
//                                     valueColor: AlwaysStoppedAnimation<Color>(
//                                       Colors.white,
//                                     ),
//                                   ),
//                                 )
//                               : Text(
//                                   'Send',
//                                   style: GoogleFonts.poppins(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w600,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: Container(
//                         height: 50,
//                         margin: const EdgeInsets.only(left: 8),
//                         child: ElevatedButton(
//                           onPressed: _clearForm,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF374151),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                           child: Text(
//                             'Clear',
//                             style: GoogleFonts.poppins(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../apiservice/apiService.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _mobileCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _messageCtrl = TextEditingController();
  final TextEditingController _remarksCtrl = TextEditingController();

  bool _isSubmitting = false;
  bool _showRemarksField = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _mobileCtrl.dispose();
    _emailCtrl.dispose();
    _messageCtrl.dispose();
    _remarksCtrl.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    // Using the enhanced feedback method
    FeedbackResult result = await ApiService.postAppFeedbackEnhanced(
      appName: "NetMeter", // You can make this dynamic
      versionNo: "1.0.0", // You can make this dynamic
      platform: "Android", // You can make this dynamic based on device
      personName: _nameCtrl.text.trim(),
      mobile: _mobileCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      message: _messageCtrl.text.trim(),
      remarks: _remarksCtrl.text.trim(),
    );

    setState(() => _isSubmitting = false);

    _showResultDialog(result.success, result.message);

    if (result.success) {
      _clearForm();
    }
  }

  void _clearForm() {
    _formKey.currentState!.reset();
    _nameCtrl.clear();
    _mobileCtrl.clear();
    _emailCtrl.clear();
    _messageCtrl.clear();
    _remarksCtrl.clear();
    setState(() => _showRemarksField = false);
  }

  void _showResultDialog(bool success, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: success
                  ? [const Color(0xFF4CAF50), const Color(0xFF8BC34A)]
                  : [const Color(0xFFF44336), const Color(0xFFE57373)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  success ? Icons.check_circle : Icons.error,
                  size: 48,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                success ? 'Success!' : 'Error!',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: success
                      ? const Color(0xFF4CAF50)
                      : const Color(0xFFF44336),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: Text(
                  'OK',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
    Widget? suffixIcon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        style: GoogleFonts.poppins(
          fontSize: 16,
          color: const Color(0xFF374151),
        ),
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: suffixIcon,
          labelStyle: GoogleFonts.poppins(
            color: const Color(0xFF6B7280),
            fontSize: 14,
          ),
          filled: true,
          fillColor: const Color(0xFFF3F4F6),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFD1D5DB), width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFD1D5DB), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF3EADCF), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFF44336), width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFF44336), width: 2),
          ),
        ),
      ),
    );
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter your name";
    }
    if (value.trim().length < 2) {
      return "Name must be at least 2 characters";
    }
    return null;
  }

  String? _validateMobile(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter your mobile number";
    }
    if (!ApiService.isValidMobile(value.trim())) {
      return "Please enter a valid 10-digit mobile number";
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter your email address";
    }
    if (!ApiService.isValidEmail(value.trim())) {
      return "Please enter a valid email address";
    }
    return null;
  }

  String? _validateMessage(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter your feedback";
    }
    if (value.trim().length < 10) {
      return "Feedback must be at least 10 characters";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF3EADCF), Color(0xFFABE9CD)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Feedback',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 8),

                      // Name Field
                      _buildTextField(
                        controller: _nameCtrl,
                        label: "Full Name *",
                        validator: _validateName,
                      ),

                      // Mobile Number Field
                      _buildTextField(
                        controller: _mobileCtrl,
                        label: "Mobile Number *",
                        keyboardType: TextInputType.phone,
                        validator: _validateMobile,
                      ),

                      // Email Field
                      _buildTextField(
                        controller: _emailCtrl,
                        label: "Email Address *",
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail,
                      ),

                      // Feedback Field
                      _buildTextField(
                        controller: _messageCtrl,
                        label: "Your Feedback *",
                        maxLines: 4,
                        validator: _validateMessage,
                      ),

                      // Add Remarks Button/Field
                      if (!_showRemarksField)
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 16),
                          child: TextButton.icon(
                            onPressed: () {
                              setState(() => _showRemarksField = true);
                            },
                            icon: const Icon(Icons.add, size: 16),
                            label: Text(
                              "Add Additional Remarks (Optional)",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: const Color(0xFF6B7280),
                              ),
                            ),
                            style: TextButton.styleFrom(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: const BorderSide(color: Color(0xFFD1D5DB)),
                              ),
                            ),
                          ),
                        ),

                      // Remarks Field (shown when requested)
                      if (_showRemarksField)
                        _buildTextField(
                          controller: _remarksCtrl,
                          label: "Additional Remarks",
                          maxLines: 2,
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.close, size: 20),
                            onPressed: () {
                              _remarksCtrl.clear();
                              setState(() => _showRemarksField = false);
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Bottom buttons
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 50,
                        margin: const EdgeInsets.only(right: 8),
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : _submitFeedback,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3EADCF),
                            disabledBackgroundColor: const Color(0xFF9CA3AF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isSubmitting
                              ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                              : Text(
                            'Submit Feedback',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 50,
                        margin: const EdgeInsets.only(left: 8),
                        child: OutlinedButton(
                          onPressed: _isSubmitting ? null : _clearForm,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF374151)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Clear Form',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF374151),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}