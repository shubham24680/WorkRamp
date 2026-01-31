

import '../../../../app.dart';

class Terms extends StatelessWidget {
  const Terms({super.key});

  // Custom Header 1 (Main Title)
  Widget h1(String text) {
    return CustomText(
      text: text,
      size: 22,
      weight: FontWeight.bold,
    );
  }

  // Custom Header 2 (Section Title)
  Widget h2(String text) {
    return CustomText(
      text: text,
      size: 16,
      weight: FontWeight.w600,
    );
  }

  // Custom Header 3 (Body Text)
  Widget h3(String text) {
    return CustomText(
      text: text,
      size: 14,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(text: "Terms of Service"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // MARK: Intro
            h1("🎯 Introduction"),
            const SizedBox(height: 5),
            h3(
              "TickIt is a task management application designed to help users organize their daily tasks, manage long-term goals, and categorize activities efficiently. Our app is built with Flutter and uses Supabase for backend services, including PostgreSQL databases and Google authentication.",
            ),
            const SizedBox(height: 20),

            // MARK: Acceptance
            h1("👥 Acceptance of Terms"),
            const SizedBox(height: 5),
            h3(
              "By using TickIt, whether as a guest or a registered user, you acknowledge that you have read, understood, and agreed to abide by these Terms of Service. If you disagree with any part of these terms, you may not use the TickIt app.",
            ),
            const SizedBox(height: 20),

            // MARK: Security
            h1("📝 Account Registration and Security"),
            const SizedBox(height: 5),
            h2("1. Account Creation"),
            h3(
              " • To use TickIt, you may be required to create an account using Google Authentication through Supabase.\n"
              " • Upon signing in, we verify your identity and store user details, such as your name and email, in our secure database.",
            ),
            const SizedBox(height: 5),
            h2("2. Profile Management"),
            h3(
              " • A user profile is automatically created upon Google sign-in.\n"
              " • If your profile is not found in the database, a new profile is inserted with a default avatar.",
            ),
            const SizedBox(height: 5),
            h2("3. User Responsibility"),
            h3(
              " • You are solely responsible for maintaining the confidentiality of your account and password.\n"
              " • You agree to notify us immediately if you suspect any unauthorized use of your account.",
            ),
            const SizedBox(height: 20),

            // MARK: Privacy
            h1("🔒 Privacy and Data Usage"),
            const SizedBox(height: 5),
            h3(
              "TickIt respects your privacy and ensures that your personal information is handled securely. We use Google Authentication and Supabase to authenticate and store user data, including task information and preferences.",
            ),
            const SizedBox(height: 20),

            // MARK: Features
            h1("📚 Features and Functionalities"),
            const SizedBox(height: 5),
            h3(
              "TickIt offers the following features:\n"
              " • Create, update, and delete daily tasks.\n"
              " • Categorize tasks into Work, Personal, and Long-term Goals.\n"
              " • Mark tasks as Completed or Pending with real-time updates.\n"
              " • View task history and track progress.",
            ),
            const SizedBox(height: 20),

            // MARK: Connectivity
            h1("📡 Internet Connectivity and Data Sync"),
            const SizedBox(height: 5),
            h3(
              "TickIt syncs data when the user is online. If the app is launched offline, data will be fetched and synced once internet connectivity is restored.",
            ),
            const SizedBox(height: 20),

            // MARK: Account Termination
            h1("🛑 Account Termination"),
            const SizedBox(height: 5),
            h2("1. Voluntary Termination"),
            h3(
              " • You may terminate your account at any time by logging out and discontinuing use of the app.\n",
            ),
            h2("2. Termination by TickIt"),
            h3(
              " • We reserve the right to suspend or terminate your account if:\n"
              "   - You violate these Terms of Service.\n"
              "   - We detect suspicious behavior that compromises security.",
            ),
            const SizedBox(height: 20),

            // MARK: Limitation of Liability
            h1("⚖️ Limitation of Liability"),
            const SizedBox(height: 5),
            h3(
              "TickIt is provided \"as is\" without warranties of any kind, whether express or implied. We do not guarantee uninterrupted service or that the app will be error-free. To the fullest extent permitted by law, TickIt shall not be liable for any damages resulting from the use of the app.",
            ),
            const SizedBox(height: 20),

            // MARK: Modifications
            h1("🔄 Changes to These Terms"),
            const SizedBox(height: 5),
            h3(
              "We may modify these Terms of Service at any time. Users will be notified of changes through the app or via email. Continued use of TickIt after modifications constitutes acceptance of the updated terms.",
            ),
            const SizedBox(height: 20),

            // MARK: Contact
            h1("📧 Contact Us"),
            const SizedBox(height: 5),
            h3(
              "If you have any questions, concerns, or feedback regarding these Terms of Service, please feel free to contact us at:\n"
              "📩 support@tickitapp.com",
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
