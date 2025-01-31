import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class AboutUsPage extends StatelessWidget {
  final List<TeamMember> teamMembers = [
    TeamMember(
      name: 'Tanveer Hussain',
      role: 'Mobile App Developer',
      contact: '0344-0307564',
      icon: Icons.phone_android,
    ),
    TeamMember(
      name: 'Mohammad Khan',
      role: 'Web Developer',
      contact: '0307-2676482',
      icon: LucideIcons.monitor,
    ),
    TeamMember(
      name: 'Syed Ghazanfar Abbas Shah',
      role: 'Writer',
      contact: '0301-2638584',
      icon: LucideIcons.penTool,
    ),
    TeamMember(
      name: 'Ghazanfar Hyder',
      role: 'Mobile App Developer',
      contact: '0321-1881365',
      icon: Icons.phone_android,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About Us',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
  padding: EdgeInsets.all(width * 0.04),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      // Description Section
      Container(
        padding: EdgeInsets.all(width * 0.05),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Colors.purple.shade300, Colors.pink.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.shade100,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              "Welcome to VoiceMate",
              style: TextStyle(
                fontSize: width * 0.065, // Adjust font size based on width
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "VoiceMate is your innovative partner in connecting people and empowering communication with cutting-edge technology. Our team is dedicated to building top-notch solutions tailored to your needs.",
              style: TextStyle(
                fontSize: width * 0.045, // Adjust font size based on width
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),

      // Team Section
      Text(
        "Meet Our Team",
        style: TextStyle(
          fontSize: width * 0.055, // Adjust font size based on width
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 10),

      // Animated List
      AnimationLimiter(
        child: Container(
          height: height * 0.6, 
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: teamMembers.length,
            itemBuilder: (context, index) {
              final member = teamMembers[index];
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 600),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: GestureDetector(
                      onTap: () {
                       
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                TeamMemberDetails(member: member),
                          ),
                        );
                      },
                      child: Card(
                        margin: EdgeInsets.symmetric(vertical: height * 0.01),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: LinearGradient(
                              colors: [Colors.purple.shade100, Colors.pink],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: ListTile(
                            leading: Hero(
                              tag: member.name,
                              child: CircleAvatar(
                                backgroundColor: Colors.purple.shade200,
                                child: Icon(member.icon, color: Colors.white),
                              ),
                            ),
                            title: Text(
                              member.name,
                              style: TextStyle(
                                fontSize: width * 0.045, // Adjust font size based on width
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              "${member.role}\nContact: ${member.contact}",
                              style: TextStyle(
                                fontSize: width * 0.035, // Adjust font size based on width
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    ],
  ),
),

    );
  }
}

class TeamMember {
  final String name;
  final String role;
  final String contact;
  final IconData icon;

  TeamMember({
    required this.name,
    required this.role,
    required this.contact,
    required this.icon,
  });
}

class TeamMemberDetails extends StatelessWidget {
  final TeamMember member;

  const TeamMemberDetails({Key? key, required this.member}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(member.name),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: member.name,
              child: CircleAvatar(
                radius: width * 0.12, // Adjust based on screen width
                backgroundColor: Colors.purple.shade200,
                child: Icon(member.icon, color: Colors.white, size: width * 0.1), // Adjust size based on width
              ),
            ),
            SizedBox(height: height * 0.02), // 2% of screen height
            Text(
              member.name,
              style: TextStyle(
                fontSize: width * 0.08,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              member.role,
              style: TextStyle(fontSize: width * 0.06, color: Colors.grey.shade600),
            ),
            SizedBox(height: height * 0.015), // 1.5% of screen height
            Text(
              "Contact: ${member.contact}",
              style: TextStyle(fontSize: width * 0.05, color: Colors.grey.shade800),
            ),
            SizedBox(height: height * 0.02), // Additional spacing if needed
          ],
        ),
      ),
    );
  }
}
