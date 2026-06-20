import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/utils/formatters.dart';
import 'package:smart_kishan/features/farmer/weather/cubit/weather_cubit.dart';
import 'package:smart_kishan/features/farmer/weather/cubit/weather_state.dart';

import 'weather_card_skeleton.dart';

class WeatherCard extends StatelessWidget {
  const WeatherCard({super.key});

  String _localizedCondition(String condition, AppLocalizations l10n) {
    switch (condition.toLowerCase()) {
      case 'thunderstorm':
        return l10n.weatherThunderstorm;
      case 'drizzle':
        return l10n.weatherDrizzle;
      case 'rain':
        return l10n.weatherRain;
      case 'snow':
        return l10n.weatherSnow;
      case 'clear':
        return l10n.weatherClear;
      case 'clouds':
        return l10n.weatherClouds;
      case 'mist':
        return l10n.weatherMist;
      case 'haze':
        return l10n.weatherHaze;
      case 'fog':
        return l10n.weatherFog;
      default:
        return condition;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<WeatherCubit, WeatherState>(
      builder: (context, state) {
        if (state is WeatherLoading) return const WeatherCardSkeleton();
        if (state is! WeatherLoaded) {
          // Failed or initial → keep the header clean.
          return const SizedBox(height: 8);
        }
        final w = state.weather;
        final good = !state.willRainToday;
        final date = DateFormat(
          'EEE d MMM',
          Localizations.localeOf(context).languageCode,
        ).format(DateTime.now());

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: colors.shadow,
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${w.cityName}, $date',
                          style: TextStyle(
                            color: colors.textSecondary,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.ld(w.temperature.round()),
                              style: TextStyle(
                                color: colors.textPrimary,
                                fontWeight: FontWeight.w700,
                                fontSize: 44,
                                height: 1.0,
                              ),
                            ),
                            Text(
                              '°C',
                              style: TextStyle(
                                color: colors.textSecondary,
                                fontWeight: FontWeight.w600,
                                fontSize: 22,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.water_drop,
                              size: 16,
                              color: colors.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${l10n.weatherHumidity} ${context.ld(w.humidity.round())}%',
                              style: TextStyle(
                                color: colors.textSecondary,
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Lottie.asset(
                          w.conditionAsset,
                          height: 72,
                          repeat: true,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _localizedCondition(w.mainCondition, l10n),
                          style: TextStyle(
                            color: colors.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Divider(color: colors.divider),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: (good ? colors.success : colors.warning).withValues(
                      alpha: 0.12,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: (good ? colors.success : colors.warning)
                          .withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        good ? Icons.check_circle : Icons.info,
                        size: 18,
                        color: good ? colors.success : colors.warning,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          good
                              ? l10n.weatherPesticideRecommended
                              : l10n.weatherPesticideNotRecommended,
                          style: TextStyle(
                            color: colors.textPrimary,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
