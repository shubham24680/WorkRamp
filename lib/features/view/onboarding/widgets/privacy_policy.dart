import 'package:flutter/material.dart';
import 'package:tickit/core/widgets/text.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  // Custom Header 1 (Main Title)
  Widget h1(String text) {
    return Inter(
      text: text,
      size: 22,
      weight: FontWeight.bold,
    );
  }

  // Custom Header 2 (Section Title)
  Widget h2(String text) {
    return Inter(
      text: text,
      size: 16,
      weight: FontWeight.w600,
    );
  }

  // Custom Header 3 (Body Text)
  Widget h3(String text) {
    return Inter(
      text: text,
      size: 14,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Inter(text: "Privacy Policy"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // MARK: Introduction
            h1("🔒 Introduction"),
            const SizedBox(height: 5),
            h3(
              "Welcome to WorkRamp! Your privacy is of utmost importance to us. "
              "This Privacy Policy outlines how we collect, use, and safeguard "
              "your information when you use our app. By accessing or using TickIt, "
              "you agree to the terms outlined in this policy.",
            ),
            const SizedBox(height: 20),

            // MARK: Information Collection
            h1("📚 Information We Collect"),
            const SizedBox(height: 5),
            h2("1. Personal Information"),
            h3(
              " • When you sign in using Google Authentication, we collect your name, email address, and profile picture.\n"
              " • If no profile picture is provided, we assign a default avatar.\n"
              " • Your UID (unique identifier) is stored to manage your tasks securely.",
            ),
            const SizedBox(height: 5),
            h2("2. Task and Usage Data"),
            h3(
              " • We store data related to your tasks, including task title, category, tag, and completion status.\n"
              " • Task metadata such as creation and modification dates is also collected.\n"
              " • User preferences for task management and organization are stored to enhance your experience.",
            ),
            const SizedBox(height: 5),
            h2("3. Device and Usage Information"),
            h3(
              " • We may collect device information, including device model, operating system, and version.\n"
              " • App usage patterns and crash reports help us identify and fix performance issues.",
            ),
            const SizedBox(height: 20),

            // MARK: How We Use Your Information
            h1("🎯 How We Use Your Information"),
            const SizedBox(height: 5),
            h3(
              "Your information is used to:\n"
              " • Provide task management services and sync task data.\n"
              " • Authenticate and secure user accounts.\n"
              " • Personalize app features to suit your task preferences.\n"
              " • Monitor and improve app performance and security.\n"
              " • Send notifications and alerts related to tasks and updates.",
            ),
            const SizedBox(height: 20),

            // MARK: Data Security
            h1("🔐 Data Security"),
            const SizedBox(height: 5),
            h3(
              "We implement industry-standard security measures to protect your data.\n"
              " • Data is encrypted during transmission using HTTPS protocols.\n"
              " • Sensitive user information is stored securely in Supabase PostgreSQL databases.\n"
              " • Row-level security (RLS) ensures that only authenticated users can access their own task data.",
            ),
            const SizedBox(height: 20),

            // MARK: Data Retention and Deletion
            h1("🗂️ Data Retention and Deletion"),
            const SizedBox(height: 5),
            h3(
              " • Your data is retained as long as your account is active.\n"
              " • You can request account deletion by contacting us, which will result in the permanent deletion of all associated data.\n"
              " • Once an account is deleted, it cannot be restored, and task data will be removed from our database.",
            ),
            const SizedBox(height: 20),

            // MARK: Sharing and Disclosure
            h1("🤝 Sharing and Disclosure"),
            const SizedBox(height: 5),
            h3(
              "We do not sell, rent, or share your personal information with third parties.\n"
              "However, we may disclose your information:\n"
              " • To comply with legal obligations or requests.\n"
              " • To service providers (such as Google and Supabase) strictly for authentication and database management.\n"
              " • To prevent fraudulent activities and ensure the security of TickIt.",
            ),
            const SizedBox(height: 20),

            // MARK: Internet Connectivity
            h1("📡 Internet Connectivity and Offline Mode"),
            const SizedBox(height: 5),
            h3(
              " • TickIt fetches and syncs task data when the user is online.\n"
              " • If the app is launched offline, previously fetched task data is displayed.\n"
              " • Data modifications made offline are synced automatically when internet connectivity is restored.",
            ),
            const SizedBox(height: 20),

            // MARK: Third-Party Integrations
            h1("🧩 Third-Party Integrations"),
            const SizedBox(height: 5),
            h3(
              "TickIt integrates with trusted third-party services:\n"
              " • Google Authentication is used to verify user identity.\n"
              " • Supabase manages and secures task data stored in the PostgreSQL database.\n"
              "These services have their own privacy policies that govern the data they collect and manage.",
            ),
            const SizedBox(height: 20),

            // MARK: User Rights
            h1("🛑 Your Rights and Control"),
            const SizedBox(height: 5),
            h3(
              "You have the right to:\n"
              " • Access and modify your personal information.\n"
              " • Request data deletion and terminate your account.\n"
              " • Opt-out of receiving notifications or alerts.\n"
              "To exercise your rights, contact us at support@tickitapp.com.",
            ),
            const SizedBox(height: 20),

            // MARK: Changes to Privacy Policy
            h1("🔄 Changes to Privacy Policy"),
            const SizedBox(height: 5),
            h3(
              "We reserve the right to update this Privacy Policy periodically. "
              "You will be notified of any changes through the app or via email. "
              "Continued use of TickIt after such updates constitutes acceptance of the modified policy.",
            ),
            const SizedBox(height: 20),

            // MARK: Contact Us
            h1("📧 Contact Us"),
            const SizedBox(height: 5),
            h3(
              "If you have any questions, concerns, or feedback about this Privacy Policy, "
              "feel free to contact us at:\n"
              "📩 support@tickitapp.com",
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
