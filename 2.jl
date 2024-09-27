using HorizonSideRobots

function move_and_count(r::Robot, side::HorizonSide)
    steps = 0
    while !isborder(r, side)
        move!(r, side)
        steps += 1
    end
    return steps
end

function move_back(r::Robot, side::HorizonSide, steps::Int)
    for _ in 1:steps
        move!(r, side)
    end
end

function mark_perimeter(r::Robot)
    # Определяем размеры поля
    steps_north = move_and_count(r, Nord)
    steps_south = move_and_count(r, Sud)
    steps_west = move_and_count(r, West)
    steps_east = move_and_count(r, Ost)

    # Возвращаемся в исходную позицию
    move_back(r, Nord, steps_north)
    move_back(r, Sud, steps_south)
    move_back(r, West, steps_west)
    move_back(r, Ost, steps_east)

    # Определяем размеры поля
    rows = steps_north + steps_south + 1
    cols = steps_west + steps_east + 1

    # Возвращаемся в левый верхний угол
    for _ in 1:steps_north
        move!(r, Nord)
    end
    for _ in 1:steps_west
        move!(r, West)
    end

    # Маркируем внешний периметр
    for side in [Ost, Sud, West, Nord]
        while !isborder(r, side)
            putmarker!(r)
            move!(r, side)
        end
        putmarker!(r)
    end

    # Возвращаемся в исходную позицию
    for _ in 1:steps_north
        move!(r, Nord)
    end
    for _ in 1:steps_west
        move!(r, West)
    end
end

# Создаем робота и запускаем функцию
r = Robot(animate=true)
mark_perimeter(r)
