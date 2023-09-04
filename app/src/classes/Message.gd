# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later
class_name Message

enum TYPE {
	SETUP,
	TEAM_PICK,
	UPDATE_ACTIVE_PLAYER,
	TRANSFER,
	AUCTION_START,
	AUCTION_END,
	AUCTION_BID,
	AUCTION_PAUSE,
	AUCTION_RESET,
}

var type:TYPE

var message:String

func decode(message:String) -> Message:
	
