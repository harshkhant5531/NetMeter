// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class AboutUs extends StatelessWidget {
//
//   @override
//   Widget build(BuildContext context) {
//
//
//     return Scaffold(
//       backgroundColor: Colors.blue.shade50,
//       extendBodyBehindAppBar: true,
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
//                     'About us',
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
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             SizedBox(height: 100),
//             Container(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: const [
//                   Image(
//                     image: AssetImage('assets/speed_test_logo_transparent.png'),
//                     height: 80,
//                   ),
//                   SizedBox(height: 10),
//                 ],
//               ),
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   margin: EdgeInsets.fromLTRB(40, 0, 0, 0),
//                   height: 28,
//                   width: 120,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(5),
//                       topRight: Radius.circular(5),
//                     ),
//                     color: Color(0xFF3EADCF),
//                   ),
//                   child: Center(
//                     child: Text(
//                       'Meet Our Team',
//                       style: TextStyle(color: Colors.white, fontSize: 15),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Container(
//               padding: const EdgeInsets.all(16.0),
//               margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//                 border: Border.all(color: Color(0xFF3EADCF), width: 1.75),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text.rich(
//                     TextSpan(
//                       children: [
//                         TextSpan(
//                           text: 'Developed by : ',
//                           style: TextStyle(color: Color(0xFF3EADCF)),
//                         ),
//                         TextSpan(
//                           text: 'Harsh Khant (23010101140)',
//                           style: TextStyle(color: Colors.black),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 5),
//                   Text.rich(
//                     TextSpan(
//                       children: [
//                         TextSpan(
//                           text: 'Mentored by : ',
//                           style: TextStyle(color: Color(0xFF3EADCF)),
//                         ),
//                         TextSpan(
//                           text:
//                               'Prof. Mehul Bhundiya, School of Computer Science',
//                           style: TextStyle(color: Colors.black),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 5),
//                   Text.rich(
//                     TextSpan(
//                       children: [
//                         TextSpan(
//                           text: 'Explored by : ',
//                           style: TextStyle(color: Color(0xFF3EADCF)),
//                         ),
//                         TextSpan(
//                           text: 'ASWDC, School of Computer Science',
//                           style: TextStyle(color: Colors.black),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 5),
//                   Text.rich(
//                     TextSpan(
//                       children: [
//                         TextSpan(
//                           text: 'Eulogized by : ',
//                           style: TextStyle(color: Color(0xFF3EADCF)),
//                         ),
//                         TextSpan(
//                           text: 'Darshan University, Rajkot, Gujarat - INDIA',
//                           style: TextStyle(color: Colors.black),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   margin: EdgeInsets.fromLTRB(40, 0, 0, 0),
//                   height: 28,
//                   width: 120,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(5),
//                       topRight: Radius.circular(5),
//                     ),
//                     color: Color(0xFF3EADCF),
//                   ),
//                   child: Center(
//                     child: Text(
//                       'About ASWDC',
//                       style: TextStyle(color: Colors.white, fontSize: 15),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Container(
//               padding: const EdgeInsets.all(16.0),
//               margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//                 border: Border.all(color: Color(0xFF3EADCF), width: 1.75),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Image.asset(
//                           'assets/darshan_University_Logo.png',
//                           height: 50,
//                         ),
//                       ),
//                       SizedBox(height: 10),
//                       Expanded(
//                         child: Image.asset('assets/ASWDC.png', height: 50),
//                       ),
//                       const SizedBox(width: 10),
//                     ],
//                   ),
//                   SizedBox(height: 10),
//                   const SizedBox(height: 10),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'ASWDC is the Application, Software and Website Development Center @ Darshan University, run by students and staff of the School of Computer Science. ',
//                         style: TextStyle(color: Colors.black),
//                         textAlign: TextAlign.justify,
//                       ),
//                       const SizedBox(height: 10),
//                       const Text(
//                         'Sole purpose is to bridge the gap between university curriculum & industry demands. Students learn cutting-edge technologies and develop real-world'
//                         'application & experiences professional environment @ASWDC under the guidance of experienced industry experts and faculty members.',
//                         style: TextStyle(color: Colors.black),
//                         textAlign: TextAlign.justify,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   margin: EdgeInsets.fromLTRB(40, 0, 0, 0),
//                   height: 28,
//                   width: 120,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(5),
//                       topRight: Radius.circular(5),
//                     ),
//                     color: Color(0xFF3EADCF),
//                   ),
//                   child: Center(
//                     child: Text(
//                       'Contact',
//                       style: TextStyle(color: Colors.white, fontSize: 15),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Container(
//               padding: const EdgeInsets.all(16.0),
//               margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//                 border: Border.all(color: Color(0xFF3EADCF), width: 1.75),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Icon(Icons.email, color: Color(0xFF3EADCF)),
//                       SizedBox(width: 10),
//                       Text(
//                         'aswdc@darshan.ac.in',
//                         style: TextStyle(fontSize: 16, color: Colors.black),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 10),
//                   Row(
//                     children: [
//                       Icon(Icons.phone, color: Color(0xFF3EADCF)),
//                       SizedBox(width: 10),
//                       Text(
//                         '+91-9727747317',
//                         style: TextStyle(fontSize: 16, color: Colors.black),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 10),
//                   Row(
//                     children: [
//                       Icon(Icons.language, color: Color(0xFF3EADCF)),
//                       SizedBox(width: 10),
//                       Text(
//                         'www.darshan.ac.in',
//                         style: TextStyle(fontSize: 16, color: Colors.black),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.all(16.0),
//               margin: const EdgeInsets.all(16.0),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//                 border: Border.all(color: Color(0xFF3EADCF), width: 1.75),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Icon(Icons.share, color: Color(0xFF3EADCF)),
//                       SizedBox(width: 10),
//                       Text(
//                         'Share App',
//                         style: TextStyle(fontSize: 16, color: Colors.black),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 10),
//                   Row(
//                     children: [
//                       Icon(Icons.apps, color: Color(0xFF3EADCF)),
//                       SizedBox(width: 10),
//                       Text(
//                         'More Apps',
//                         style: TextStyle(fontSize: 16, color: Colors.black),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 10),
//                   Row(
//                     children: [
//                       Icon(Icons.star_border, color: Color(0xFF3EADCF)),
//                       SizedBox(width: 10),
//                       Text(
//                         'Rate Us',
//                         style: TextStyle(fontSize: 16, color: Colors.black),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 10),
//                   Row(
//                     children: [
//                       Icon(Icons.thumb_up, color: Color(0xFF3EADCF)),
//                       SizedBox(width: 10),
//                       Text(
//                         'Like us on Facebook',
//                         style: TextStyle(fontSize: 16, color: Colors.black),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 10),
//                   Row(
//                     children: [
//                       Icon(Icons.autorenew_outlined, color: Color(0xFF3EADCF)),
//                       SizedBox(width: 10),
//                       Text(
//                         'Check For Update',
//                         style: TextStyle(fontSize: 16, color: Colors.black),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 10),
//             Column(
//               children: [
//                 Text(
//                   '© ${DateTime.now().year} Darshan University',
//                   style: TextStyle(color: Colors.black),
//                 ),
//                 Container(
//                   margin: EdgeInsets.symmetric(horizontal: 60),
//                   child: FittedBox(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           'All Rights Reserved - ',
//                           style: TextStyle(color: Colors.black),
//                         ),
//                         Text(
//                           'Privacy Policy',
//                           style: TextStyle(color: Colors.blue),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Center(
//                   child: FittedBox(
//                     child: Container(
//                       margin: EdgeInsets.symmetric(horizontal: 108),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.favorite, color: Colors.red, size: 20),
//                           Text(
//                             ' in India',
//                             style: TextStyle(color: Colors.black),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'widgets/about_button.dart';
import '../utils/import_export.dart';

class AboutUs extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      extendBodyBehindAppBar: true,
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
                    'About us',
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 100),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: const [
                  Image(
                    image: AssetImage('assets/speed_test_logo_transparent.png'),
                    height: 80,
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(40, 0, 0, 0),
                  height: 28,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                    ),
                    color: Color(0xFF3EADCF),
                  ),
                  child: Center(
                    child: Text(
                      'Meet Our Team',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Color(0xFF3EADCF), width: 1.75),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Developed by : ',
                          style: TextStyle(color: Color(0xFF3EADCF)),
                        ),
                        TextSpan(
                          text: 'Harsh Khant (23010101140)',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Mentored by : ',
                          style: TextStyle(color: Color(0xFF3EADCF)),
                        ),
                        TextSpan(
                          text:
                          'Prof. Mehul Bhundiya, School of Computer Science',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Explored by : ',
                          style: TextStyle(color: Color(0xFF3EADCF)),
                        ),
                        TextSpan(
                          text: 'ASWDC, School of Computer Science',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Eulogized by : ',
                          style: TextStyle(color: Color(0xFF3EADCF)),
                        ),
                        TextSpan(
                          text: 'Darshan University, Rajkot, Gujarat - INDIA',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(40, 0, 0, 0),
                  height: 28,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                    ),
                    color: Color(0xFF3EADCF),
                  ),
                  child: Center(
                    child: Text(
                      'About ASWDC',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Color(0xFF3EADCF), width: 1.75),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Image.asset(
                          'assets/darshan_University_Logo.png',
                          height: 50,
                        ),
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: Image.asset('assets/ASWDC.png', height: 50),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                  SizedBox(height: 10),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ASWDC is the Application, Software and Website Development Center @ Darshan University, run by students and staff of the School of Computer Science. ',
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Sole purpose is to bridge the gap between university curriculum & industry demands. Students learn cutting-edge technologies and develop real-world'
                            'application & experiences professional environment @ASWDC under the guidance of experienced industry experts and faculty members.',
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(40, 0, 0, 0),
                  height: 28,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                    ),
                    color: Color(0xFF3EADCF),
                  ),
                  child: Center(
                    child: Text(
                      'Contact',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Color(0xFF3EADCF), width: 1.75),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => _sendEmail('aswdc@darshan.ac.in'),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                      child: Row(
                        children: [
                          Icon(Icons.email, color: Color(0xFF3EADCF)),
                          SizedBox(width: 10),
                          Text(
                            'aswdc@darshan.ac.in',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  InkWell(
                    onTap: () => _openDialer('+919727747317'),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                      child: Row(
                        children: [
                          Icon(Icons.phone, color: Color(0xFF3EADCF)),
                          SizedBox(width: 10),
                          Text(
                            '+91-9727747317',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  InkWell(
                    onTap: () => _visitWebsite('www.darshan.ac.in'),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                      child: Row(
                        children: [
                          Icon(Icons.language, color: Color(0xFF3EADCF)),
                          SizedBox(width: 10),
                          Text(
                            'www.darshan.ac.in',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Color(0xFF3EADCF), width: 1.75),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VisibleButton(
                    icon: Icons.share,
                    label: 'Share App',
                    onTap: _shareApp,
                  ),
                  VisibleButton(
                    icon: Icons.apps,
                    label: 'More Apps',
                    onTap: _openMoreApps,
                  ),
                  VisibleButton(
                    icon: Icons.star_border,
                    label: 'Rate Us',
                    onTap: _rateApp,
                  ),
                  VisibleButton(
                    icon: Icons.thumb_up,
                    label: 'Like us on Facebook',
                    onTap: _openFacebook,
                  ),
                  VisibleButton(
                    icon: Icons.autorenew_outlined,
                    label: 'Check For Update',
                    onTap: _checkForUpdate,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Column(
              children: [
                Text(
                  '© ${DateTime.now().year} Darshan University',
                  style: TextStyle(color: Colors.black),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 60),
                  child: FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'All Rights Reserved - ',
                          style: TextStyle(color: Colors.black),
                        ),
                        // Clickable Privacy Policy
                        InkWell(
                          onTap: () => _openPrivacyPolicy(),
                          child: Text(
                            'Privacy Policy',
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: FittedBox(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 108),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.favorite, color: Colors.red, size: 20),
                          Text(
                            ' in India',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openDialer(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    await launchUrl(launchUri); // Opens dialer, user taps call
  }


  Future<void> _sendEmail(String email) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Hello from Speed Test App&body=Hi ASWDC Team,',
    );
    try {
      if (!await launchUrl(launchUri)) {
        throw Exception('Could not launch $launchUri');
      }
    } catch (e) {
      print('Error opening email: $e');
    }
  }

  Future<void> _visitWebsite(String url) async {
    final Uri uri = Uri.parse(url.startsWith('http') ? url : 'https://$url');
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $uri');
      }
    } catch (e) {
      print('Error opening website: $e');
    }
  }

  void _shareApp() {
    Share.share(
      'Check out this amazing Speed Test app developed by ASWDC, Darshan University! Download it from Play Store: https://play.google.com/store/apps/details?id=com.aswdc.speedtest',
      subject: 'Speed Test App - ASWDC',
    );
  }

  Future<void> _openMoreApps() async {
    final Uri url = Uri.parse('https://play.google.com/store/apps/developer?id=ASWDC+Darshan+University');
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      print('Error opening more apps: $e');
    }
  }

  Future<void> _rateApp() async {
    final Uri url = Uri.parse('https://play.google.com/store/apps/details?id=com.aswdc.speedtest');
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      print('Error opening rate app: $e');
    }
  }

  Future<void> _openFacebook() async {
    final Uri facebookUrl = Uri.parse('fb://page/darshanuniversity'); // Facebook app
    final Uri webUrl = Uri.parse('https://www.facebook.com/darshanuniversity'); // Web fallback

    try {
      if (!await launchUrl(facebookUrl)) {
        await launchUrl(webUrl, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      try {
        await launchUrl(webUrl, mode: LaunchMode.externalApplication);
      } catch (e) {
        print('Error opening Facebook: $e');
      }
    }
  }

  Future<void> _checkForUpdate() async {
    final Uri url = Uri.parse('https://play.google.com/store/apps/details?id=com.aswdc.speedtest');
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      print('Error checking for update: $e');
    }
  }

  Future<void> _openPrivacyPolicy() async {
    final Uri url = Uri.parse('https://www.darshan.ac.in/privacy-policy');
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      print('Error opening privacy policy: $e');
    }
  }

}


