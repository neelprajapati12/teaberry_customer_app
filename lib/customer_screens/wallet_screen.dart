import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:teaberryapp_project/constants/api_constant.dart';
import 'package:teaberryapp_project/constants/app_colors.dart';
import 'package:teaberryapp_project/constants/sizedbox_util.dart';
import 'package:teaberryapp_project/shared_pref.dart';

class WalletScreen extends StatefulWidget {
  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  // final Map<String, dynamic> referralStats = {
  //   "totalReferrals": 0,
  //   "totalBonusEarned": 0,
  //   "pendingReferrals": 0,
  //   "successfulReferrals": 0,
  // };

  final List<Map<String, dynamic>> referralHistory = [
    {
      'name': 'John Doe',
      'phone': '+91 9876543210',
      'status': 'Successful',
      'date': 'May 15, 2023',
      'bonus': '50',
    },
    {
      'name': 'Jane Smith',
      'phone': '+91 8765432109',
      'status': 'Pending',
      'date': 'May 10, 2023',
      'bonus': '50',
    },
    {
      'name': 'Robert Johnson',
      'phone': '+91 7654321098',
      'status': 'Successful',
      'date': 'May 5, 2023',
      'bonus': '50',
    },
  ];

  // dynamic referralstats = [];
  dynamic referralhistory = [];

  Map<String, dynamic> referralstats = {
    'totalReferrals': 0,
    'totalBonusEarned': 0,
    'pendingReferrals': 0,
    'successfulReferrals': 0,
  };

  // Update the getreferralstats() function
  Future<void> getreferralstats() async {
    try {
      final url = Uri.parse('${ApiConstant.baseUrl}/api/referrals/stats');
      print(url);

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${SharedPreferencesHelper.getTokencustomer()}',
        },
      );

      if (response.statusCode == 200) {
        print("Referral Stats Fetched Successfully");
        final Map<String, dynamic> decoded = json.decode(response.body);
        setState(() {
          referralstats = {
            'totalReferrals': decoded['totalReferrals'] ?? 0,
            'totalBonusEarned': decoded['totalBonusEarned'] ?? 0,
            'pendingReferrals': decoded['pendingReferrals'] ?? 0,
            'successfulReferrals': decoded['successfulReferrals'] ?? 0,
          };
        });
      } else {
        print('Failed to fetch stats: ${response.body}');
      }
    } catch (e) {
      print('Error fetching referral stats: $e');
    }
  }

  Future<void> getreferralhistory() async {
    final url = Uri.parse('${ApiConstant.baseUrl}/api/referrals/history');
    print(url);

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${SharedPreferencesHelper.getTokencustomer()}',
      },
    );

    if (response.statusCode == 200) {
      print("Referral History Fetched Successfully");
      print("Referral History Fetched - ${response.body}");
      final decoded = json.decode(response.body);
      setState(() {
        referralhistory = decoded;
      });

      // print(referralhistory);
    } else {
      print('Failed to fetch History: ${response.body}');
    }
  }

  @override
  void initState() {
    super.initState();
    getreferralstats();
    getreferralhistory();
  }

  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Wallet",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: const BackButton(),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total Coins Card
            Container(
              height: h * 0.15,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Wallet Balance',
                      style: TextStyle(color: Colors.grey, fontSize: 20),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₹ ${SharedPreferencesHelper.getcustomerwalletbalance()}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Referral Stats Section
            const Text(
              'Referral Statistics',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildStatCard(
                  'Total Referrals',
                  referralstats['totalReferrals'].toString(),
                  Icons.people_alt_outlined,
                  Colors.blue,
                ),
                _buildStatCard(
                  'Total Bonus',
                  '₹${referralstats['totalBonusEarned']}',
                  Icons.monetization_on_outlined,
                  Appcolors.green,
                ),
                _buildStatCard(
                  'Pending',
                  referralstats['pendingReferrals'].toString(),
                  Icons.pending_actions_outlined,
                  Colors.orange,
                ),
                _buildStatCard(
                  'Successful',
                  referralstats['successfulReferrals'].toString(),
                  Icons.check_circle_outline,
                  Colors.purple,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Referral History Section
            const Text(
              'Referral History',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...referralhistory
                .map((referral) => _buildReferralItem(referral))
                .toList(),
            const SizedBox(height: 16),

            // Referral Info Section
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'How it works',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• When you refer a friend, and they make their first order of minimum ₹ 100, you will receive ₹ 50 as a referral bonus.',
                    style: TextStyle(color: Colors.grey.shade800),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• Usage of referral bonus: 20% of the order value can be used as referral discount if Min order is of ₹ 500. Max referral discount is ₹ 200 per order.',
                    style: TextStyle(color: Colors.grey.shade800),
                  ),
                ],
              ),
            ),
            vSize(20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReferralItem(Map<String, dynamic> referral) {
    final referred = referral['referred'];
    final referredName = referred?['name'] ?? 'N/A';
    final referredPhone = referred?['mobile'] ?? 'N/A';
    final bonus = referral['bonusGiven'] ?? 0;
    final rawDate = referral['createdAt'] ?? '';
    final status = bonus > 0 ? 'Successful' : 'Pending';

    // Format date
    String formattedDate = '';
    try {
      formattedDate = DateTime.parse(
        rawDate,
      ).toLocal().toString().split('.')[0].replaceAll('T', ' ');
    } catch (_) {
      formattedDate = 'N/A';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: name + status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  referredName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color:
                        status == 'Successful'
                            ? Colors.green.shade100
                            : Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color:
                          status == 'Successful'
                              ? Colors.green.shade800
                              : Colors.orange.shade800,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Mobile No - $referredPhone",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 8),
                // Text(
                //   formattedDate,
                //   style: TextStyle(color: Colors.grey.shade600),
                // ),
                Text(
                  '₹$bonus',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Appcolors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
