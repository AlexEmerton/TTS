uno_deck_GUID = '6c5098'
random_greetings = {
    [1] = "Good to see you ",
    [2] = "Celebrity sighting! What an honour to have you ",
    [3] = "Oh no, it's ",
    [4] = "Their Imperial Highness is here, all hail ",
    [5] = "Oh hey there, ",
}

function onload()
    printGreeting()
    greetPlayers(random_greetings)
    spawned_start_button = spawnStartButton()
    createStartButton(spawned_start_button)
end

function spawnStartButton()
    local params = {}
    params.type = 'Quarter'
    params.position = {0, 1, 6}
    params.scale = {1, 1, 1}

    return spawnObject(params)
end

function createStartButton(object)
    button_attributes = {}
    button_attributes.click_function = 'startGame'
    button_attributes.function_owner = nil
    button_attributes.label = 'Let\'s go!'
    button_attributes.position = {0, 0, 0, 0}
    button_attributes.rotation = {0, 180, 0}
    button_attributes.width = 2000
    button_attributes.height = 2000
    button_attributes.font_size = 500

    object.setColorTint({r=1, g=1, b=1, a=0})
    object.createButton(button_attributes)
end

function shuffleCardDeck(deck)
    deck.shuffle()
end

function dealCardsToPlayers(deck)
    deck.deal(7)
end

function moveDeckAway(deck)
    deck.setPositionSmooth({10, 5, 0, 0})
end

function resetDeck(deck)
    deck.setPositionSmooth({0, 3, 0, 0})
end

function getAllCurrentCardsInHand()
    cards_in_hands = {}
    players = Player.getPlayers()

    for player_ind, player_val in pairs(players) do
        objectsInHand = player_val.getHandObjects()

        for obj_ind, obj_val in pairs(objectsInHand) do
            table.insert(cards_in_hands, obj_val)
        end
    end
    return cards_in_hands
end

function collectHandCards(deck)
    cards_in_hands = getAllCurrentCardsInHand()

    for i, card in pairs(cards_in_hands) do
        deck.putObject(card)
    end
end

function startGame()
    for i=1, 20 do
        print()
    end
    uno_deck = getObjectFromGUID(uno_deck_GUID)

    printGameStartMessage()
    resetDeck(uno_deck)
    shuffleCardDeck(uno_deck)
    dealCardsToPlayers(uno_deck)
    moveDeckAway(uno_deck)
    collectHandCards(uno_deck)
end

function printGreeting()
    print("Welcome to Simply UNO everyone! Let's get this party started...")
end

function printGameStartMessage()
    random_game_start_msg = {
        [1] = "Take no prisoners!",
        [2] = [["Never interrupt your enemy when he is making a mistake."
    — Napoleon Bonaparte ]],
        [3] = [["An eye for an eye makes the whole world blind."
    — Gandhi]],
        [4] = "Never give up! Until you do...",
        [5] = [["Before you embark on a journey of revenge, you should first dig two graves."
    — Confucius ]],
    }

    greeting_random_ind = math.random(1, 5)
    printToAll(random_game_start_msg[greeting_random_ind], {r=1, g=1, b=0})
end

function greetPlayers(greetings)
    players = Player.getPlayers()
    greeting_random_ind = math.random(1, 5)

    for player_ind, player_val in pairs(players) do
        printToAll(greetings[greeting_random_ind] .. player_val.steam_name .. "!",  {r=0, g=1, b=0.5})
    end
end
