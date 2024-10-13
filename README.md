# layered_architecture

my_app/
├── lib/
│   ├── main.dart
│   ├── presentation/
│   │   ├── pages/
│   │   │   └── user_page.dart
│   │   ├── widgets/
│   │   │   └── user_widget.dart
│   │   └── blocs/
│   │       └── user_bloc.dart
│   ├── domain/
│   │   ├── models/
│   │   │   └── user.dart
│   │   ├── repositories/
│   │   │   └── user_repository.dart
│   ├── application/
│   │   ├── services/
│   │   │   ├── user_service.dart
│   │   │   └── shop_service.dart
│   │   └── use_cases/
│   ├── data/
│   │   ├── repositories/
│   │   │   └── in_memory_user_repository.dart
│   │   ├── datasources/
│   │   └── cache/
│   ├── utils/
│       └── lock_manager.dart
└── pubspec.yaml