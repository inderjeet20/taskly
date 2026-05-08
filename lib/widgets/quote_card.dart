import 'package:flutter/material.dart';
import 'package:taskly/models/quote_model.dart';
import 'package:taskly/utils/app_colors.dart';
import 'package:taskly/widgets/glass_card.dart';
import 'package:taskly/widgets/loading_widget.dart';

class QuoteCard extends StatelessWidget {
  const QuoteCard({
    super.key,
    required this.quote,
    required this.isLoading,
    required this.onRefresh,
  });

  final QuoteModel quote;
  final bool isLoading;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Motivation',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              IconButton(
                onPressed: isLoading ? null : onRefresh,
                icon: const Icon(
                  Icons.refresh_rounded,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          if (isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: LoadingWidget(message: 'Refreshing quote...'),
            )
          else ...[
            const SizedBox(height: 4),
            Text(
              '"${quote.content}"',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                height: 1.6,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              quote.author,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
