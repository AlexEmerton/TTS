UNO_DECK_GUID = 'aa2acc'
SCRIPTING_ZONE_GUID = '08f652'
NUMBER_OF_GAMES_PLAYED = 0

function onload()
    -- Greet players
    printWelcomeMessage()
    printPlayerGreetings()

    -- Create the game start button
    createStartButton()
end

-- function onObjectEnterScriptingZone(zone, enter_obj)
--     print(zone.tag)
--     if enter_obj.tag == 'Card' then
--         if not enter_obj.is_face_down then
--             print("Dropped a card!")
--         end
--     end
-- end

function spawnStartButton()
    local params = {}
    params.type = 'FogOfWar'
    params.position = {0, 1, 6}
    params.scale = {1, 1, 1}

    return spawnObject(params)
end

function createStartButton()
    spawned_start_button = spawnStartButton()

    button_attributes = {}
    button_attributes.click_function = 'startGame'
    button_attributes.color = {r=0, g=1, b=1}
    button_attributes.font_color = {r=1, g=1, b=1}
    button_attributes.function_owner = nil
    button_attributes.label = 'Let\'s go!'
    button_attributes.position = {0, 0, 0, 0}
    button_attributes.rotation = {0, 180, 0}
    button_attributes.width = 2000
    button_attributes.height = 2000
    button_attributes.font_size = 500

    spawned_start_button.createButton(button_attributes)
end

function shuffleCardDeck(deck)
    deck.shuffle()
end

function dealCardsToPlayers(deck)
    deck.deal(7)
end

function moveDeckAway(deck)
    deck.setPositionSmooth({10, 2, 0, 0})
end

function resetDeckPosition(deck)
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

function collectAllPlayedCards(zone)
    objects_in_play = zone.getObjects()

    if next(objects_in_play) == nil then
        -- Exit early if there's nothing in play
        return
    else
        for i, object in pairs(objects_in_play) do
            if (object.tag == 'Card') or (object.tag == 'Deck' and object.guid != 'aa2acc') then
                object.destruct()
                -- deck.putObject(card)
            end
        end
    end
end

function collectAllCardsInHands(deck)
    cards_in_hands = getAllCurrentCardsInHand()

    if next(cards_in_hands) == nil then
        -- Exit early if there's nothing in hands
        return
    else
        for i, card in pairs(cards_in_hands) do
            -- card.flip()
            deck.putObject(card)
        end
    end
end

function startGame()
    NUMBER_OF_GAMES_PLAYED = NUMBER_OF_GAMES_PLAYED + 1
    -- Clear the chat
    for i=1, 5 do
        print()
    end
    print("Starting game number " .. NUMBER_OF_GAMES_PLAYED)

    uno_deck = getObjectFromGUID(UNO_DECK_GUID)
    scripting_zone = getObjectFromGUID(SCRIPTING_ZONE_GUID)

    printGameStartMessage()

    if NUMBER_OF_GAMES_PLAYED == 1 then
        moveDeckAway(uno_deck)
    end
    uno_deck.reset()
    collectAllPlayedCards(scripting_zone)
    -- collectAllCardsInHands(uno_deck)

    -- Wait.time(function() collectAllPlayedCards(zone) end, 2)
    dealCardsToPlayers(uno_deck)
    -- shuffleCardDeck(uno_deck)
end

function printWelcomeMessage()
    print("Welcome to Simply UNO everyone! Let's get this party started...")
end

function printGameStartMessage()
    random_game_start_msg = {
        [1] = [["In war there is no prize for the runner-up."
    — General Omar Bradley ]],
        [2] = [["Never interrupt your enemy when he is making a mistake."
    — Napoleon Bonaparte ]],
        [3] = [["An eye for an eye makes the whole world blind."
    — Gandhi]],
        [4] = [["Death solves all problems - no man, no problem."
    — Joseph Stalin ]],
        [5] = [["Before you embark on a journey of revenge, you should first dig two graves."
    — Confucius ]],
    }

    greeting_random_ind = math.random(1, 5)
    broadcastToAll(random_game_start_msg[greeting_random_ind], {r=1, g=1, b=0})
end

function printPlayerGreetings()
    random_greetings = {
        [1] = "Good to see you ",
        [2] = "Celebrity sighting! What an honour to have you ",
        [3] = "Oh no, it's ",
        [4] = "Their Imperial Highness is here, all hail ",
        [5] = "Oh hey there, ",
    }
    players = Player.getPlayers()
    greeting_random_ind = math.random(1, 5)

    for player_ind, player_val in pairs(players) do
        broadcastToAll(random_greetings[greeting_random_ind] .. player_val.steam_name .. "!",  {r=0, g=1, b=0.5})
    end
end
