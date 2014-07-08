require_relative '../lib/wwtd.rb'

# Creating World
quest1 = WWTD.db.create_quest(name: 'Quest 1', data: {first_completed_action: nil, last_completed_action: nil, last_lr_action: nil, entered_living_room: false, killed_first_zombie: false})

# Rooms
# Room ID 1
bedroom = WWTD.db.create_room(name: "Your Bedroom",
                    description: "It's a cozy room that is relatively small. Your dresser is in the far corner with a jacket tossed on top of it. There's a bedstand next to your bed with a few pictures on it, including one of you and your good friend Susie.",
                    canS: false,
                    canE: false,
                    quest_id: quest1.id,
                    start_new_quest: true
                    )
# Room ID 2
bathroom = WWTD.db.create_room(name: "Player's Bathroom",
                    description: "A pretty average bathroom with an inviting shower, the basics (toothbrush, toothpaste) laying on the counter, and a toilet.",
                    east: bedroom.id,
                    canS: false,
                    canN: false,
                    canW: false,
                    quest_id: quest1.id
                    )
# Room ID 3
living_room = WWTD.db.create_room(name: "Player's Living Room",
                    description: "Man, it's bright in your living room today. Guess you must have left the curtains open. The TV, which hangs on the left wall is off, and your backpack is tossed in the corner near the door.",
                    south: bedroom.id,
                    canN: false,
                    canE: false,
                    canW: false,
                    quest_id: quest1.id
                    )


WWTD.db.update_room(bedroom.id, west: bathroom.id, north: living_room.id)

# Characters
WWTD.db.create_character(name: "First Zombie",
                        description: "HOLY SHIT! IT'S A REAL ZOMBIE AGAIN! Coming at ya fast and through that shining living room window",
                        strength: 20,
                        classification: 'zombie',
                        room_id: living_room.id,
                        quest_id: quest1.id
                        )
WWTD.db.create_character(name: "Susie",
                        description: "Your best friend at the hospital.",
                        classification: 'person',
                        room_id: 10,
                        quest_id: quest1.id
                        )

# items
cell = WWTD.db.create_item(classification: 'item',
                                name: 'phone',
                                description: "An iPhone that's been dropped nearly one too many times",
                                actions: 'answer, pick up, call',
                                room_id: bedroom.id
                                )
dresser = WWTD.db.create_item(classification: 'item',
                                name: 'dresser',
                                description: "An elegant cherry wood dresser with a jacket tossed on top and 2 drawers, one slightly ajar",
                                actions: 'open',
                                room_id: bedroom.id
                                )
jacket = WWTD.db.create_item(classification: 'item',
                                name: 'jacket',
                                description: "A comfy UT jacket left over from the good ole days",
                                actions: 'put on, wear, pick up, take',
                                room_id: bedroom.id
                                )
socks = WWTD.db.create_item(classification: 'item',
                                name: 'socks',
                                description: "A pair of grungy white socks that have held up over the years",
                                actions: 'put on, wear, pick up, take',
                                parent_item: dresser.id,
                                room_id: bedroom.id
                                )
shower = WWTD.db.create_item(classification: 'item',
                                name: 'shower',
                                description: "You know what it is. ",
                                actions: 'get in, use, clean, take, shower',
                                room_id: bathroom.id
                                )
toothpaste = WWTD.db.create_item(classification: 'item',
                                name: 'toothpaste',
                                description: "So fresh and so clean, clean. ",
                                actions: 'take',
                                room_id: bathroom.id
                                )
toothbrush = WWTD.db.create_item(classification: 'item',
                                name: 'toothbrush',
                                description: "Don't you think you're a little old for a Spiderman toothbrush? Nah.... ",
                                actions: 'use, take, brush',
                                room_id: bathroom.id
                                )
tv = WWTD.db.create_item(classification: 'item',
                                name: 'tv',
                                description: "A badass 80inch TV that a roommate once left in your lucky lucky possession.",
                                actions: 'turn on, watch',
                                room_id: living_room.id
                                )
backpack = WWTD.db.create_item(classification: 'item',
                                name: 'backpack',
                                description: "A trusty backpack that can fit a surprising number of medical books",
                                actions: 'put on, take, pick up',
                                room_id: living_room.id
                                )

WWTD.db.create_quest_item(item_id: backpack.id, quest_id: quest1.id, room_id: backpack.room_id)
WWTD.db.create_quest_item(item_id: tv.id, quest_id: quest1.id, room_id: tv.room_id)
WWTD.db.create_quest_item(item_id: toothbrush.id, quest_id: quest1.id, room_id: toothbrush.room_id)
WWTD.db.create_quest_item(item_id: toothpaste.id, quest_id: quest1.id, room_id: toothpaste.room_id)
WWTD.db.create_quest_item(item_id: shower.id, quest_id: quest1.id, room_id: shower.room_id)
WWTD.db.create_quest_item(item_id: socks.id, quest_id: quest1.id, room_id: socks.room_id)
WWTD.db.create_quest_item(item_id: jacket.id, quest_id: quest1.id, room_id: jacket.room_id)
WWTD.db.create_quest_item(item_id: dresser.id, quest_id: quest1.id, room_id: dresser.room_id)
WWTD.db.create_quest_item(item_id: cell.id, quest_id: quest1.id, room_id: cell.room_id)

