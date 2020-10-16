class Timer
    def initialize
        @start_time = nil
        @end_time = nil
    end

    def start
        @start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    end

    def stop
        @end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    end

    def time_ellapsed_in_sec
        @end_time - @start_time
    end

    def time_ellapsed_in_min_sec
        seconds = time_ellapsed_in_sec
        min = (seconds/60).floor
        sec_remainder = (seconds - (min * 60)).floor
        min.to_s.rjust(2, "0") + ":" + sec_remainder.to_s.rjust(2, "0")
    end

end