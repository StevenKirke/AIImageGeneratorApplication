# AIImageGeneratorApplication

## Description
#### Данное приложение является тестовой работой, для генерации обоев с помощью AI (stablediffusion):
#### Навыки:
##### * работа с сохранением картинок на телефон,
##### * кастомные шрифты,
##### * воспроизведение звуков на iPhone, 
##### * "верской кода с использованием  SnapKit",
##### * "Cocoapods",

#### Включает в себя сцены:
##### * "GenerateImage",
##### * "howPicture".

## Getting started
#####

## Usage
#### Запустить файл iWeather.xcworkspace.

## Architecture
#### В данном проекте используется архитектура Clean Architecture.

## Structure

``` bash
└── AIImageGenerator
│   ├── README.md
│   ├── swiftlint.yml
│   └── AIImageGenerator
│       ├── GlobalStyles
│       │   └── FontStyle.swift
│       ├── Converted
│       │   └── ConvertGenerateImageDTO.swift
│       ├── Managers
│       │   ├── DecodeJSONManager.swift
│       │   ├── NetworkManager.swift
│       │   ├── NetworkKingfisherManager.swift
│       │   └── SavePhotoManager.swift
│       ├── Services
│       │   └── AssemblerURLService.swift
│       ├── Extensions
│       │   ├── Extension+UIColor.swift
│       │   ├── Extension+UITextField.swift
│       │   └── Extension+UIApplication.swift
│       ├── Coordinators
│       │   │── Common
│       │   │   ├── AppCoordinator.swift
│       │   │   └── ICoordinator.swift
│       │   └── GenerateImageCoordinator.swift
│       ├── Flows
│       │   └── GenerateFlow
│       │       ├── GenerateImageScene
│      	│       │   ├── GenerateImageAssembler.swift
│       │       │   ├── GenerateImageViewController.swift
│       │       │   ├── GenerateImageIterator.swift
│       │       │   ├── GenerateImagePresenter.swift
│       │       │   ├── GenerateImageModel.swift
│       │       │   └── Worker+DTO
│       │       │       ├── GenerateImageWorker.swift
│       │       │       └── GenerateImageDTO.swift
│       │     	└── ShowPictureScene
│      	│           ├── ShowPictureAssembler.swift
│       │           ├── ShowPictureViewModel.swift
│       │           ├── ShowPictureIterator.swift
│       │           ├── ShowPicturePresenter.swift
│       │           └── ShowPictureModel.swift
│       ├── Application
│       │   ├── AppDelegate.swift
│       │   └── SceneDelegate.swift
│       └── Resources
│           ├── AnimationClock.json
│           │   └── Fonds
│           │         └── SFProDisplaySemibold
│           ├── LaunchScreen.storyboard
│           ├── Assets.xcassets
│            └── Info.plist
└── Pods
```

## Running the tests

## Dependencies Pods
#### Добавлен пакет SnapKit& 
#### Добавлен пакет EasyTipView& 
#### Добавлен пакет Kingfisher& 
#### Добавлен пакет lottie-ios& 

## Workflow
#### XCode version: 15.2 
#### iOS version: 14.2

## Design
#### Дизайн для приложения выполнен по картинке.

## Task boards
#### Для координации используется Kaiten.

## API
#### В приложении используются API:
##### * [stablediffusionapi API ](https://stablediffusionapi.com/docs/stable-diffusion-api/text2img/) 
