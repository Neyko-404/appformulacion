import 'package:flutter/material.dart';
import 'package:focusly/features/academic_tracker/domain/entities/course.dart';

Color courseVisualColor(BuildContext context, CourseVisualIdentity identity) {
  final scheme = Theme.of(context).colorScheme;
  return switch (identity) {
    CourseVisualIdentity.ocean => scheme.primary,
    CourseVisualIdentity.forest => scheme.tertiary,
    CourseVisualIdentity.sunset => scheme.error,
    CourseVisualIdentity.violet => scheme.secondary,
    CourseVisualIdentity.amber => scheme.tertiaryContainer,
    CourseVisualIdentity.rose => scheme.errorContainer,
  };
}
