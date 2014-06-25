require_relative '../lib/wwtd/wwtd.rb'

# Creating World
# Rooms
bedroom = WWTD.db.create_room(name: "Player's Bedroom",
                    description: "A cozy room that you don't see nearly enough of due to your demanding job at the hospital",
                    canS: false,
                    canE: false
                    )

bathroom = WWTD.db.create_room(name: "Player's Bathroom",
                    description: "Just your average bathroom with an inviting shower, the basics (toothbrush, toothpaste, comb), and a toilet.",
                    west: bedroom.id,
                    canS: false,
                    canN: false,
                    canW: false
                    )

living_room = WWTD.db.create_room(name: "Player's Living Room",
                    description: "Man, it's bright in your living room today. Guess you must have left the curtains open.",
                    south: bedroom.id,
                    canN: false,
                    canE: false,
                    canW: false
                    )

WWTD.db.update_room(bedroom.id, west: bathroom.id, north: living_room.id)

# Quests
quest1 = WWTD.db.create_quest(name: 'Quest 1')

# Characters
WWTD.db.create_character(name: "HOLY SHIT! IT'S A REAL ZOMBIE AGAIN!",
                        description: "Coming at ya fast and through that shining living room window",
                        strength: 20,
                        classification: 'zombie',
                        room_id: living_room.id,
                        quest_id: quest1.id
                        )
def build_item(item)
      WWTD::ItemNode.new(id: item.id,
        classification: item.classification,
        name: item.name,
        description: item.description,
        actions: item.actions,
        parent_item: item.parent_item,
        room_id: item.room_id
      )
    end
# items
WWTD.db.create_item(classification: 'item',
                                name: 'Your cell phone',
                                description: "An iPhone that's been dropped nearly one too many times",
                                actions: 'answer, pick up, call',
                                room_id: bedroom.id
                                )
dresser = WWTD.db.create_item(classification: 'item',
                                name: 'Bedroom dresser',
                                description: "An elegant cherry wood dresser with a jacket tossed on top and 2 drawers, one slightly ajar",
                                actions: 'open',
                                room_id: bedroom.id
                                )
WWTD.db.create_item(classification: 'item',
                                name: 'Jacket',
                                description: "A comfy UT jacket left over from the good ole days",
                                actions: 'put on, wear, pick up, take',
                                room_id: bedroom.id
                                )
WWTD.db.create_item(classification: 'item',
                                name: 'White socks',
                                description: "A pair of grungy white socks that have held up over the years",
                                actions: 'put on, wear, pick up, take',
                                parent_item: dresser.id,
                                room_id: bedroom.id
                                )
WWTD.db.create_item(classification: 'item',
                                name: 'Underwear',
                                description: "Your last clean pair of underwear (it really is time to do some laundry)",
                                actions: 'put on, wear, pick up, take',
                                parent_item: dresser.id,
                                room_id: bedroom.id
                                )
WWTD.db.create_item(classification: 'item',
                                name: 'Your bathroom shower',
                                description: "You know what it is. ",
                                actions: 'get in, use, take, shower',
                                room_id: bathroom.id
                                )
WWTD.db.create_item(classification: 'item',
                                name: 'Toothpaste',
                                description: "So fresh and so clean, clean. ",
                                actions: 'use, put on, take',
                                room_id: bathroom.id
                                )
WWTD.db.create_item(classification: 'item',
                                name: 'Toothbrush',
                                description: "Don't you think you're a little old for a Spiderman toothbrush? Nah.... ",
                                actions: 'use, take, brush',
                                room_id: bathroom.id
                                )
WWTD.db.create_item(classification: 'item',
                                name: 'TV',
                                description: "A badass 80inch TV that a roommate once left in your lucky lucky possession.",
                                actions: 'turn on, watch',
                                room_id: living_room.id
                                )
WWTD.db.create_item(classification: 'item',
                                name: 'backpack',
                                description: "A trusty backpack that can fit a surprising number of calculus textbooks",
                                actions: 'use, take, brush',
                                room_id: living_room.id
                                )
