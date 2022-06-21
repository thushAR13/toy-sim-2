class Api::RobotController < ApplicationController
  def orders
    @commands = params[:commands]
    @x, @y, @dir = 0,0, ""
    @max, @min = 4,0 
    validate()
    eval()
  end
  
  private 

  def validate()
    count = 0
    for i in 0..@commands.length - 1 do
      if @commands[i][0] == 'P'
        break
      else
        count += 1
      end
    end
    @commands = @commands.drop(count)
  end

  def eval()
    for i in 0..@commands.length - 1 do
      cmd = @commands[i].downcase!.gsub(","," ").split(" ")

      if cmd[0] == 'place'
        if (cmd[1].to_i >= @min && cmd[1].to_i <= @max) && (cmd[2].to_i >= @min && cmd[2].to_i <= @max)
          place(cmd[1].to_i,cmd[2].to_i,cmd[3])

        end
      elsif cmd[0] == 'move'
        move()

      elsif cmd[0] == 'left' || cmd[0] == 'right'
        rotate(cmd[0])

      elsif cmd[0] == 'report'          
        report()
      end
    end
  end

  def place(x,y,dir)   
    @x = x
    @y = y
    @dir = dir
  end
  
  def move
    if @dir == 'north' && @y < @max
      @y += 1
    elsif @dir == 'south' && @y > @min
      @y -= 1
    elsif @dir == 'east' && @x < @max
      @x += 1
    elsif @dir =='west' && @x > @min
      @x -= 1
    end
  end

  def rotate(side)
    if side == 'left'
      if @dir == 'north'
        @dir = 'west'
      elsif @dir == 'west'
        @dir = 'south'
      elsif @dir == 'south'
        @dir = 'east'
      else
        @dir = 'north'
      end
    else
      if @dir == 'north'
        @dir = 'east'
      elsif @dir == 'east'
        @dir = 'south'
      elsif @dir == 'south'
        @dir = 'west'
      else
        @dir = 'north'
      end
    end
  end

  def report
    render json:  { location: [@x,@y,@dir.upcase] }
  end
end
