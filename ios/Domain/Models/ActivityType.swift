import Foundation

enum ActivityType: String, Codable, CaseIterable {
    case run = "Run"
    case dogRun = "DogRun"
    case strollerRun = "StrollerRun"
    case treadmillRun = "TreadmillRun"
    case trailRun = "TrailRun"
    case bikeRide = "Ride"
    case eBikeRide = "EBikeRide"
    case commuteRide = "CommuteRide"
    case recumbentRide = "RecumbentRide"
    case handCycling = "HandCycling"
    case walk = "Walk"
    case dogWalk = "DogWalk"
    case strollerWalk = "StrollerWalk"
    case treadmillWalk = "TreadmillWalk"
    case hotGirlWalk = "HotGirlWalk"
    case walkWithCane = "WalkWithCane"
    case walkWithWalker = "WalkWithWalker"
    case walkingMeeting = "WalkingMeeting"
    case deskWalk = "DeskWalk"
    case dance = "Dance"
    case cardioDance = "CardioDance"
    case stepCount = "Step Count"
    case hike = "Hike"
    case rucking = "Rucking"
    case kayak = "Kayaking"
    case paddleSports = "PaddleSports"
    case sailing = "Sailing"
    case crossCountrySkiing = "CrossCountrySkiing"
    case downhillSkiing = "DownhillSkiing"
    case snowboard = "Snowboard"
    case snowSports = "SnowSports"
    case skateboard = "Skateboarding"
    case wheelchairWalk = "Wheelchair Walk Pace"
    case wheelchairRun = "Wheelchair Run Pace"
    case virtualRide = "VirtualRide"
    case traditionalStrengthTraining = "TraditionalStrengthTraining"
    case functionalStrengthTraining = "FunctionalStrengthTraining"
    case adaptiveStrengthTraining = "AdaptiveStrengthTraining"
    case stairClimbing = "StairClimbing"
    case boxing = "Boxing"
    case kickboxing = "Kickboxing"
    case martialArts = "MartialArts"
    case taiChi = "TaiChi"
    case wrestling = "Wrestling"
    case climbing = "Climbing"
    case swimming = "Swimming"
    case waterFitness = "WaterFitness"
    case waterPolo = "WaterPolo"
    case waterSports = "WaterSports"
    case coreTraining = "CoreTraining"
    case pilates = "Pilates"
    case yoga = "Yoga"
    case hiit = "HIIT"
    case flexibility = "Flexibility"
    case gymnastics = "Gymnastics"
    case basketball = "Basketball"
    case baseball = "Baseball"
    case handball = "Handball"
    case softball = "Softball"
    case americanFootball = "AmericanFootball"
    case australianFootball = "AustralianFootball"
    case soccer = "Soccer"
    case archery = "Archery"
    case badminton = "Badminton"
    case golf = "Golf"
    case pickleball = "Pickleball"
    case tennis = "Tennis"
    case tableTennis = "TableTennis"
    case squash = "Squash"
    case racquetball = "Racquetball"
    case cricket = "Cricket"
    case volleyball = "Volleyball"
    case bowling = "Bowling"
    case hockey = "Hockey"
    case discSports = "DiscSports"
    case lacrosse = "Lacrosse"
    case rugby = "Rugby"
    case equestrianSports = "EquestrianSports"
    case fencing = "Fencing"
    case hunting = "Hunting"
    case barre = "Barre"
    case curling = "Curling"
    case surfing = "Surfing"
    case rollerskating = "Rollerskating"
    case elliptical = "Elliptical"
    case rowing = "Rowing"
    case jumpRope = "JumpRope"
    
    var displayName: String {
        switch self {
        case .run: return "Run"
        case .dogRun: return "Dog Run"
        case .strollerRun: return "Stroller Run"
        case .treadmillRun: return "Treadmill Run"
        case .trailRun: return "Trail Run"
        case .bikeRide: return "Bike Ride"
        case .eBikeRide: return "E-Bike Ride"
        case .commuteRide: return "Commute"
        case .recumbentRide: return "Recumbent Bike"
        case .handCycling: return "Hand Cycling"
        case .walk: return "Walk"
        case .dogWalk: return "Dog Walk"
        case .strollerWalk: return "Stroller Walk"
        case .treadmillWalk: return "Treadmill Walk"
        case .hotGirlWalk: return "Hot Girl Walk"
        case .walkWithCane: return "Walk with Cane"
        case .walkWithWalker: return "Walk with Walker"
        case .walkingMeeting: return "Walking Meeting"
        case .deskWalk: return "Desk Walk"
        case .dance: return "Dance"
        case .cardioDance: return "Cardio Dance"
        case .stepCount: return "Steps"
        case .hike: return "Hike"
        case .rucking: return "Rucking"
        case .kayak: return "Kayaking"
        case .paddleSports: return "Paddle Sports"
        case .sailing: return "Sailing"
        case .crossCountrySkiing: return "Cross Country Skiing"
        case .downhillSkiing: return "Downhill Skiing"
        case .snowboard: return "Snowboarding"
        case .snowSports: return "Snow Sports"
        case .skateboard: return "Skateboarding"
        case .wheelchairWalk: return "Wheelchair Walk"
        case .wheelchairRun: return "Wheelchair Run"
        case .virtualRide: return "Virtual Ride"
        case .traditionalStrengthTraining: return "Strength Training"
        case .functionalStrengthTraining: return "Functional Strength"
        case .adaptiveStrengthTraining: return "Adaptive Strength"
        case .stairClimbing: return "Stair Climbing"
        case .boxing: return "Boxing"
        case .kickboxing: return "Kickboxing"
        case .martialArts: return "Martial Arts"
        case .taiChi: return "Tai Chi"
        case .wrestling: return "Wrestling"
        case .climbing: return "Climbing"
        case .swimming: return "Swimming"
        case .waterFitness: return "Water Fitness"
        case .waterPolo: return "Water Polo"
        case .waterSports: return "Water Sports"
        case .coreTraining: return "Core Training"
        case .pilates: return "Pilates"
        case .yoga: return "Yoga"
        case .hiit: return "HIIT"
        case .flexibility: return "Flexibility"
        case .gymnastics: return "Gymnastics"
        case .basketball: return "Basketball"
        case .baseball: return "Baseball"
        case .handball: return "Handball"
        case .softball: return "Softball"
        case .americanFootball: return "Football"
        case .australianFootball: return "Australian Football"
        case .soccer: return "Soccer"
        case .archery: return "Archery"
        case .badminton: return "Badminton"
        case .golf: return "Golf"
        case .pickleball: return "Pickleball"
        case .tennis: return "Tennis"
        case .tableTennis: return "Table Tennis"
        case .squash: return "Squash"
        case .racquetball: return "Racquetball"
        case .cricket: return "Cricket"
        case .volleyball: return "Volleyball"
        case .bowling: return "Bowling"
        case .hockey: return "Hockey"
        case .discSports: return "Disc Sports"
        case .lacrosse: return "Lacrosse"
        case .rugby: return "Rugby"
        case .equestrianSports: return "Equestrian"
        case .fencing: return "Fencing"
        case .hunting: return "Hunting"
        case .barre: return "Barre"
        case .curling: return "Curling"
        case .surfing: return "Surfing"
        case .rollerskating: return "Roller Skating"
        case .elliptical: return "Elliptical"
        case .rowing: return "Rowing"
        case .jumpRope: return "Jump Rope"
        }
    }
    
    var iconName: String {
        switch self {
        case .run, .trailRun, .treadmillRun, .dogRun, .strollerRun:
            return "figure.run"
        case .bikeRide, .eBikeRide, .commuteRide, .recumbentRide, .handCycling, .virtualRide:
            return "figure.outdoor.cycle"
        case .walk, .dogWalk, .strollerWalk, .treadmillWalk, .hotGirlWalk, .walkWithCane, .walkWithWalker, .walkingMeeting, .deskWalk:
            return "figure.walk"
        case .hike, .rucking:
            return "figure.hiking"
        case .swimming, .waterFitness, .waterPolo, .waterSports:
            return "figure.pool.swim"
        case .yoga:
            return "figure.yoga"
        case .dance, .cardioDance:
            return "figure.dance"
        case .boxing, .kickboxing, .martialArts:
            return "figure.boxing"
        case .climbing:
            return "figure.climbing"
        case .snowboard, .crossCountrySkiing, .downhillSkiing, .snowSports:
            return "figure.skiing.downhill"
        case .traditionalStrengthTraining, .functionalStrengthTraining, .adaptiveStrengthTraining:
            return "figure.strengthtraining.traditional"
        case .soccer:
            return "figure.soccer"
        case .basketball:
            return "figure.basketball"
        case .tennis:
            return "figure.tennis"
        case .rowing:
            return "figure.rower"
        case .elliptical:
            return "figure.elliptical"
        case .stairClimbing:
            return "figure.stairs"
        case .coreTraining:
            return "figure.core.training"
        case .pilates:
            return "figure.pilates"
        case .golf:
            return "figure.golf"
        case .skateboard:
            return "figure.skateboarding"
        case .surfing:
            return "figure.surfing"
        case .barre:
            return "figure.barre"
        case .hiit:
            return "figure.highintensity.intervaltraining"
        default:
            return "figure.mixed.cardio"
        }
    }
    
    var isRunning: Bool {
        switch self {
        case .run, .trailRun, .treadmillRun, .dogRun, .strollerRun:
            return true
        default:
            return false
        }
    }
    
    var isCycling: Bool {
        switch self {
        case .bikeRide, .eBikeRide, .commuteRide, .recumbentRide, .handCycling, .virtualRide:
            return true
        default:
            return false
        }
    }
    
    var isWalking: Bool {
        switch self {
        case .walk, .dogWalk, .strollerWalk, .treadmillWalk, .hotGirlWalk, .walkWithCane, .walkWithWalker, .walkingMeeting, .deskWalk:
            return true
        default:
            return false
        }
    }
}
