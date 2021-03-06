module Hotel
  class FrontDesk 
    attr_reader :rooms
    def initialize
        @rooms = []
        # Refactor: custom range - rooms. Rooms include Comparable, and implement succ and <=>
        # See range doc
        (1..20).each do |n|
          @rooms << Room.new(n)
        end
    end

    def reserve_room(start_date, end_date)
      date_range = Hotel::DateRange.new(start_date, end_date)
      room = find_room(date_range)
      return room.add(date_range)
    end

    def get_avail_rooms(start_date, end_date)
      date_range = Hotel::DateRange.new(start_date, end_date)
      avail_rooms = rooms.find_all { |room|
        room.available?(date_range)
      }
      return avail_rooms
    end

    def get_reservations(date)
      reservations_at_date = []
      rooms.each do |room|
        room.reservations.each do |reservation| 
          if reservation.include?(date) && reservation.class != Block
            reservations_at_date << reservation
          end
        end
      end
      return reservations_at_date
    end
  
    private
    def find_room(date_range)
      room = rooms.find {|r|
        r.reservations.length == 0
      }
      if room == nil
        room = rooms.find {|r|
          r.available?(date_range)
        }
      end
      if room == nil
        raise ArgumentError.new("No rooms are availble in that date range.")
      end
      return room
    end

  end
end
