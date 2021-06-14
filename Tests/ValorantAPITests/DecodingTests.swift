import XCTest
@testable import ValorantAPI

final class DecodingTests: XCTestCase {
	func testDecodingCompUpdates() throws {
		let matches = try decode([CompetitiveUpdate].self, fromJSONNamed: "comp_updates")
		//dump(matches)
		XCTAssertEqual(matches.count, 20)
	}
	
	func testDecodingMatch() throws {
		let details = try decode(MatchDetails.self, fromJSONNamed: "match")
		//dump(details)
		XCTAssertEqual(details.players.count, 10)
	}
	
	func testDecodingEscalation() throws {
		let details = try decode(MatchDetails.self, fromJSONNamed: "escalation")
		//dump(details)
		XCTAssertEqual(details.players.count, 10)
	}
	
	func testDecodingContracts() throws {
		let details = try decode(ContractDetails.self, fromJSONNamed: "contracts")
		//dump(details)
		XCTAssertEqual(details.contracts.count, 23)
	}
	
	func testDecodingLivePregameInfo() throws {
		let pregameInfo = try decode(LivePregameInfo.self, fromJSONNamed: "pregame_match")
		//dump(pregameInfo)
		XCTAssertEqual(pregameInfo.team.players.count, 5)
	}
	
	func testDecodingLiveGameInfo() throws {
		let gameInfo = try decode(LiveGameInfo.self, fromJSONNamed: "live_match")
		//dump(gameInfo)
		XCTAssertEqual(gameInfo.players.count, 10)
	}
	
	private func decode<Value>(
		_ value: Value.Type = Value.self,
		fromJSONNamed filename: String
	) throws -> Value where Value: Decodable {
		let url = Bundle.module.url(forResource: "examples/\(filename)", withExtension: "json")!
		let json = try Data(contentsOf: url)
		return try ValorantClient.responseDecoder.decode(Value.self, from: json)
	}
}
