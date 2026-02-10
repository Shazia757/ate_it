import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../controllers/onboarding_controller.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final OnboardingController controller = Get.put(OnboardingController());

    final List<Map<String, String>> pages = [
      {
        'title': 'Save Food, Save Money',
        'desc':
            'Get delicious meals from your favorite restaurants at half the price.',
        'icon': 'Icon(Icons.discount)', // Placeholder for graphic
      },
      {
        'title': 'Fight Food Waste',
        'desc': 'Join the movement to reduce food waste and help the planet.',
        'icon': 'Icon(Icons.recycling)',
      },
      {
        'title': 'Eat Great Today',
        'desc': 'Discover what\'s available nearby and grab a bite instantly.',
        'icon': 'Icon(Icons.restaurant)',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.teal,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                itemCount: pages.length,
                onPageChanged: controller.updateIndex,
                itemBuilder: (context, index) {
                  return _buildPage(pages[index], context);
                },
              ),
            ),

            // Indicators
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(pages.length, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 10,
                      width: controller.pageIndex.value == index ? 24 : 10,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    );
                  }),
                )),

            const SizedBox(height: 32),

            // Next/Get Started Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Obx(() {
                final isLast = controller.pageIndex.value == pages.length - 1;
                return ElevatedButton(
                  onPressed: isLast
                      ? controller.completeOnboarding
                      : () => controller.pageController
                          .nextPage(duration: 300.ms, curve: Curves.ease),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.teal,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    isLast ? 'Get Started' : 'Next',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ).animate(target: isLast ? 1 : 0).scale(duration: 300.ms);
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(Map<String, String> data, BuildContext context) {
    IconData iconData;
    if (data['title']!.contains('Save'))
      iconData = Icons.savings;
    else if (data['title']!.contains('Fight'))
      iconData = Icons.eco;
    else
      iconData = Icons.fastfood;

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(iconData, size: 100, color: Colors.white)
                .animate()
                .scale(duration: 600.ms, curve: Curves.elasticOut),
          ),
          const SizedBox(height: 48),
          Text(
            data['title']!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.3),
          const SizedBox(height: 16),
          Text(
            data['desc']!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ).animate().fadeIn(delay: 200.ms, duration: 500.ms),
        ],
      ),
    );
  }
}
