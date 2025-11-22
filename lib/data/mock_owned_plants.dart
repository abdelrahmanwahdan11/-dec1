import '../models/owned_plant.dart';
import 'mock_plants.dart';

final mockOwnedPlants = [
  OwnedPlant.fromPlant(mockPlants[0]),
  OwnedPlant.fromPlant(mockPlants[1]).copyWith(
    nickname: 'Sunny corner',
    location: 'Balcony shelf',
    health: PlantHealth.steady,
  ),
];
