import XCTest
@testable import ValorantAPI

final class DecodingTests: XCTestCase {
	func testDecodingCompUpdates() throws {
		let matches = try decode([CompetitiveUpdate].self, fromJSONNamed: "comp_updates")
		//dump(matches)
		XCTAssertEqual(matches.count, 20)
	}
	
	func testDecodingCompSummary() throws {
		let summary = try decode(CareerSummary.self, fromJSONNamed: "career_summary")
		dump(summary)
		//XCTAssertEqual(matches.count, 20)
	}
	
	func testDecodingMatch() throws {
		let details = try decode(MatchDetails.self, fromJSONNamed: "match")
		//dump(details)
		XCTAssertEqual(details.players.count, 10)
	}
	
	func testDecodingDeathmatch() throws {
		let details = try decode(MatchDetails.self, fromJSONNamed: "deathmatch")
		//dump(details)
		XCTAssertEqual(details.players.count, 14)
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
	
	func testDecodingParty() throws {
		let party = try decode(Party.self, fromJSONNamed: "party")
		//dump(party)
		XCTAssert(party.queueEntryTime < .now)
		XCTAssert(party.state == .inMatchmaking)
	}
	
	func testDecodingInventory() throws {
		let rawInventory = try decode(APIInventory.self, fromJSONNamed: "inventory")
		let inventory = Inventory(rawInventory)
		dump(inventory)
		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
		let reencoded = String(bytes: try encoder.encode(inventory), encoding: .utf8)!
		print(reencoded)
		XCTAssertEqual(inventory.agentsIncludingStarters.count, 19)
	}
	
	func testDecodingLoadout() throws {
		let loadout = try decode(Loadout.self, fromJSONNamed: "loadout")
		dump(loadout)
		XCTAssertEqual(loadout.guns.count, 18)
	}
	
	func testDecodingStoreOffers() throws {
		let response = try decode(StoreOffersRequest.Response.self, fromJSONNamed: "store_offers")
		dump(response)
		XCTAssertEqual(response.offers.count, 398)
	}
	
	func testDecodingStorefront() throws {
		let storefront = try decode(Storefront.self, fromJSONNamed: "storefront")
		dump(storefront)
		XCTAssertEqual(storefront.skinsPanelLayout.singleItemOffers.count, 4)
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
