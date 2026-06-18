#!/bin/bash

# Root files location stays as-is (main.dart, firebase_options.dart, injection_container.dart)

# App shell
mkdir -p lib/app/router
mkdir -p lib/app/theme


# Core
mkdir -p lib/core/constants
mkdir -p lib/core/enums
mkdir -p lib/core/localization
mkdir -p lib/core/bloc
mkdir -p lib/core/network
mkdir -p lib/core/services
mkdir -p lib/core/utils
mkdir -p lib/core/widgets

# Shared
mkdir -p lib/shared/models

# Startup
mkdir -p lib/features/startup/bloc

# Language
mkdir -p lib/features/language/bloc
mkdir -p lib/features/language/data
mkdir -p lib/features/language/screens
mkdir -p lib/features/language/widgets

# Onboarding
mkdir -p lib/features/onboarding/bloc
mkdir -p lib/features/onboarding/screens
mkdir -p lib/features/onboarding/widgets

# Auth
mkdir -p lib/features/auth/bloc/otp_bloc
mkdir -p lib/features/auth/data
mkdir -p lib/features/auth/screens
mkdir -p lib/features/auth/widgets

# Profile
mkdir -p lib/features/profile/bloc
mkdir -p lib/features/profile/data
mkdir -p lib/features/profile/screens
mkdir -p lib/features/profile/widgets

# Farmer mode
mkdir -p lib/features/farmer/dashboard/bloc
mkdir -p lib/features/farmer/dashboard/screens
mkdir -p lib/features/farmer/dashboard/widgets

mkdir -p lib/features/farmer/farmlands/bloc
mkdir -p lib/features/farmer/farmlands/data
mkdir -p lib/features/farmer/farmlands/screens
mkdir -p lib/features/farmer/farmlands/widgets

mkdir -p lib/features/farmer/inventory/bloc
mkdir -p lib/features/farmer/inventory/data
mkdir -p lib/features/farmer/inventory/screens
mkdir -p lib/features/farmer/inventory/widgets

mkdir -p lib/features/farmer/daily_activity/bloc
mkdir -p lib/features/farmer/daily_activity/data
mkdir -p lib/features/farmer/daily_activity/screens
mkdir -p lib/features/farmer/daily_activity/widgets

mkdir -p lib/features/farmer/ledger/bloc
mkdir -p lib/features/farmer/ledger/data
mkdir -p lib/features/farmer/ledger/screens
mkdir -p lib/features/farmer/ledger/widgets

mkdir -p lib/features/farmer/notes/bloc
mkdir -p lib/features/farmer/notes/data
mkdir -p lib/features/farmer/notes/screens
mkdir -p lib/features/farmer/notes/widgets

mkdir -p lib/features/farmer/my_users/bloc
mkdir -p lib/features/farmer/my_users/data
mkdir -p lib/features/farmer/my_users/screens
mkdir -p lib/features/farmer/my_users/widgets

mkdir -p lib/features/farmer/crop_info/bloc
mkdir -p lib/features/farmer/crop_info/data
mkdir -p lib/features/farmer/crop_info/screens
mkdir -p lib/features/farmer/crop_info/widgets

mkdir -p lib/features/farmer/kalimati_price/bloc
mkdir -p lib/features/farmer/kalimati_price/data
mkdir -p lib/features/farmer/kalimati_price/screens
mkdir -p lib/features/farmer/kalimati_price/widgets

mkdir -p lib/features/farmer/weather/bloc
mkdir -p lib/features/farmer/weather/data
mkdir -p lib/features/farmer/weather/screens
mkdir -p lib/features/farmer/weather/widgets

# Marketplace (Buyer mode)
mkdir -p lib/features/marketplace/dashboard/bloc
mkdir -p lib/features/marketplace/dashboard/screens
mkdir -p lib/features/marketplace/dashboard/widgets

mkdir -p lib/features/marketplace/products/bloc
mkdir -p lib/features/marketplace/products/data
mkdir -p lib/features/marketplace/products/screens
mkdir -p lib/features/marketplace/products/widgets

mkdir -p lib/features/marketplace/cart/bloc
mkdir -p lib/features/marketplace/cart/data
mkdir -p lib/features/marketplace/cart/screens
mkdir -p lib/features/marketplace/cart/widgets

mkdir -p lib/features/marketplace/orders/bloc
mkdir -p lib/features/marketplace/orders/data
mkdir -p lib/features/marketplace/orders/screens
mkdir -p lib/features/marketplace/orders/widgets

mkdir -p lib/features/marketplace/delivery_address/bloc
mkdir -p lib/features/marketplace/delivery_address/data
mkdir -p lib/features/marketplace/delivery_address/screens
mkdir -p lib/features/marketplace/delivery_address/widgets

# Vendor (Seller mode)
mkdir -p lib/features/vendor/dashboard/bloc
mkdir -p lib/features/vendor/dashboard/screens
mkdir -p lib/features/vendor/dashboard/widgets

mkdir -p lib/features/vendor/sell_products/bloc
mkdir -p lib/features/vendor/sell_products/data
mkdir -p lib/features/vendor/sell_products/screens
mkdir -p lib/features/vendor/sell_products/widgets

mkdir -p lib/features/vendor/orders/bloc
mkdir -p lib/features/vendor/orders/data
mkdir -p lib/features/vendor/orders/screens
mkdir -p lib/features/vendor/orders/widgets

mkdir -p lib/features/vendor/buyers_group/bloc
mkdir -p lib/features/vendor/buyers_group/data
mkdir -p lib/features/vendor/buyers_group/screens
mkdir -p lib/features/vendor/buyers_group/widgets

# Govt services
mkdir -p lib/features/govt_services/subsidies/bloc
mkdir -p lib/features/govt_services/subsidies/data
mkdir -p lib/features/govt_services/subsidies/screens
mkdir -p lib/features/govt_services/subsidies/widgets

mkdir -p lib/features/govt_services/subsidy_requests/bloc
mkdir -p lib/features/govt_services/subsidy_requests/data
mkdir -p lib/features/govt_services/subsidy_requests/screens
mkdir -p lib/features/govt_services/subsidy_requests/widgets

mkdir -p lib/features/govt_services/complaints/bloc
mkdir -p lib/features/govt_services/complaints/data
mkdir -p lib/features/govt_services/complaints/screens
mkdir -p lib/features/govt_services/complaints/widgets

mkdir -p lib/features/govt_services/service_centers/bloc
mkdir -p lib/features/govt_services/service_centers/data
mkdir -p lib/features/govt_services/service_centers/screens
mkdir -p lib/features/govt_services/service_centers/widgets

mkdir -p lib/features/govt_services/surveys/bloc
mkdir -p lib/features/govt_services/surveys/data
mkdir -p lib/features/govt_services/surveys/screens
mkdir -p lib/features/govt_services/surveys/widgets

# Chatbot
mkdir -p lib/features/chatbot/bloc
mkdir -p lib/features/chatbot/screens

echo "✅ Folder structure created successfully."
