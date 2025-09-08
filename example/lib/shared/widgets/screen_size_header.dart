import 'package:flutter/material.dart';

import 'package:example/shared/widgets/category_chip.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

class ScreenSizeHeader extends StatelessWidget {
  const ScreenSizeHeader({
    required this.sizeName,
    super.key,
    this.range,
    this.screenData,
    this.columns,
    this.category,
    this.icon,
    this.orientation,
    this.customInfo = const [],
    this.isFullHeight = false,
  });

  final String sizeName;
  final String? range;
  final ScreenSizeModelData? screenData;
  final int? columns;
  final String? category;
  final IconData? icon;
  final String? orientation;
  final List<ScreenSizeInfoItem> customInfo;
  final bool isFullHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final content = Column(
      mainAxisSize: isFullHeight ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment:
          isFullHeight ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: 48,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 12),
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (category != null) ...[
              CategoryChip(category: category!),
              const SizedBox(width: 12),
            ],
            Flexible(
              child: Text(
                sizeName,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        if (range != null) ...[
          const SizedBox(height: 8),
          Text(
            range!,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.secondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
        if (orientation != null) ...[
          const SizedBox(height: 8),
          ScreenSizeInfoChip(
            label: '',
            value: orientation!,
            color: theme.colorScheme.primary,
          ),
        ],
        if (screenData != null || columns != null || customInfo.isNotEmpty) ...[
          const SizedBox(height: 16),
          _InfoRow(
            screenData: screenData,
            columns: columns,
            customInfo: customInfo,
          ),
        ],
      ],
    );

    if (isFullHeight) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: content,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: content,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    this.screenData,
    this.columns,
    this.customInfo = const [],
  });

  final ScreenSizeModelData? screenData;
  final int? columns;
  final List<ScreenSizeInfoItem> customInfo;

  @override
  Widget build(BuildContext context) {
    final infoItems = <Widget>[];

    if (screenData != null) {
      infoItems.addAll([
        ScreenSizeInfoChip(
          label: 'Width',
          value: '${screenData!.logicalScreenWidth.toStringAsFixed(0)}px',
        ),
        ScreenSizeInfoChip(
          label: 'Height',
          value: '${screenData!.logicalScreenHeight.toStringAsFixed(0)}px',
        ),
      ]);
    }

    if (columns != null) {
      infoItems.add(
        ScreenSizeInfoChip(
          label: 'Columns',
          value: columns.toString(),
        ),
      );
    }

    infoItems.addAll(
      customInfo.map(
        (item) => ScreenSizeInfoChip(
          label: item.label,
          value: item.value,
          color: item.color,
        ),
      ),
    );

    return Wrap(
      spacing: 12,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: infoItems,
    );
  }
}

class ScreenSizeInfoChip extends StatelessWidget {
  const ScreenSizeInfoChip({
    required this.label,
    required this.value,
    super.key,
    this.color,
  });

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chipColor = color ?? theme.colorScheme.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label.isNotEmpty) ...[
          Text(
            label,
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 4),
        ],
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 12,
            vertical: label.isEmpty ? 8 : 6,
          ),
          decoration: BoxDecoration(
            color: chipColor.withValues(alpha: 0.1),
            border: Border.all(color: chipColor.withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: chipColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class ScreenSizeInfoItem {
  const ScreenSizeInfoItem({
    required this.label,
    required this.value,
    this.color,
  });

  final String label;
  final String value;
  final Color? color;
}
