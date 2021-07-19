import Foundation

public struct CompetitiveSummary: Codable, Identifiable {
	public var userID: User.ID
	public var newPlayerExperienceFinished: Bool
	@_StringKeyedDictionary
	public var skillsByQueue: [QueueID: QueueInfo]
	/// - Note: This may not be what you expect—it's not limited to competitive matches.
	public var latestUpdate: CompetitiveUpdate?
	public var isAnonymizedOnLeaderboard: Bool
	public var isActRankBadgeHidden: Bool
	
	public var id: User.ID { userID }
	
	public var competitiveInfo: QueueInfo? {
		get { skillsByQueue[.competitive] }
		set { skillsByQueue[.competitive] = newValue }
	}
	
	private enum CodingKeys: String, CodingKey {
		case userID = "Subject"
		case newPlayerExperienceFinished = "NewPlayerExperienceFinished"
		case skillsByQueue = "QueueSkills"
		case latestUpdate = "LatestCompetitiveUpdate"
		case isAnonymizedOnLeaderboard = "IsLeaderboardAnonymized"
		case isActRankBadgeHidden = "IsActRankBadgeHidden"
	}
	
	public struct QueueInfo: Codable {
		public var totalGamesNeededForRating: Int
		public var totalGamesNeededForLeaderboard: Int
		/// When a new act starts within the same episode, you need less games to get ranked. This seems to be that number (when applicable & outstanding).
		public var gamesNeededForRatingWithinEpisode: Int
		public var bySeason: [Season.ID: SeasonInfo]?
		
		public func inSeason(_ id: Season.ID?) -> SeasonInfo? {
			id.flatMap { bySeason?[$0] }
		}
		
		public init(from decoder: Decoder) throws {
			let container = try decoder.container(keyedBy: CodingKeys.self)
			
			totalGamesNeededForRating = try container.decode(Int.self, forKey: .totalGamesNeededForRating)
			totalGamesNeededForLeaderboard = try container.decode(Int.self, forKey: .totalGamesNeededForLeaderboard)
			gamesNeededForRatingWithinEpisode = try container.decode(Int.self, forKey: .gamesNeededForRatingWithinEpisode)
			
			// ugh
			if decoder.isDecodingFromRiot {
				bySeason = try container.decodeIfPresent(
					_StringKeyedDictionary<Season.ID, SeasonInfo>.self,
					forKey: .bySeason
				)?.wrappedValue
			} else {
				bySeason = try container.decodeIfPresent(
					[Season.ID: SeasonInfo].self,
					forKey: .bySeason
				)
			}
		}
		
		private enum CodingKeys: String, CodingKey {
			case totalGamesNeededForRating = "TotalGamesNeededForRating"
			case totalGamesNeededForLeaderboard = "TotalGamesNeededForLeaderboard"
			case gamesNeededForRatingWithinEpisode = "CurrentSeasonGamesNeededForRating"
			case bySeason = "SeasonalInfoBySeasonID"
		}
	}
	
	public struct SeasonInfo: Codable {
		public var seasonID: Season.ID
		public var winCount: Int
		public var winCountIncludingPlacements: Int
		public var gameCount: Int
		public var actRank: Int
		/// - Note: Seems to always be 0.
		public var capstoneWins: Int
		public var leaderboardRank: Int
		public var competitiveTier: Int
		public var rankedRating: Int
		public var winsByTier: [Int: Int]?
		public var gamesNeededForRating: Int
		public var totalWinsNeededForRank: Int
		
		public init(
			seasonID: Season.ID,
			winCount: Int = 0,
			winCountIncludingPlacements: Int = 0,
			gameCount: Int = 0,
			actRank: Int,
			capstoneWins: Int = 0,
			leaderboardRank: Int = 0,
			competitiveTier: Int,
			rankedRating: Int,
			winsByTier: [Int : Int]? = nil,
			gamesNeededForRating: Int = 0,
			totalWinsNeededForRank: Int = 0
		) {
			self.seasonID = seasonID
			self.winCount = winCount
			self.winCountIncludingPlacements = winCountIncludingPlacements
			self.gameCount = gameCount
			self.actRank = actRank
			self.capstoneWins = capstoneWins
			self.leaderboardRank = leaderboardRank
			self.competitiveTier = competitiveTier
			self.rankedRating = rankedRating
			self.winsByTier = winsByTier
			self.gamesNeededForRating = gamesNeededForRating
			self.totalWinsNeededForRank = totalWinsNeededForRank
		}
		
		private enum CodingKeys: String, CodingKey {
			case seasonID = "SeasonID"
			case winCount = "NumberOfWins"
			case winCountIncludingPlacements = "NumberOfWinsWithPlacements"
			case gameCount = "NumberOfGames"
			case actRank = "Rank"
			case capstoneWins = "CapstoneWins"
			case leaderboardRank = "LeaderboardRank"
			case competitiveTier = "CompetitiveTier"
			case rankedRating = "RankedRating"
			case winsByTier = "WinsByTier"
			case gamesNeededForRating = "GamesNeededForRating"
			case totalWinsNeededForRank = "TotalWinsNeededForRank"
		}
	}
}
