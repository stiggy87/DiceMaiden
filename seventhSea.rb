require 'pp'

class Array
  def contains_all? other
    other = other.dup
    each{|e| if i = other.index(e) then other.delete_at(i) end}
    other.empty?
  end

  def combine(prods)
    prods.map(&:flatten)
         .each_with_object(Hash.new {|h,k| h[k]=[]}) { |(k,v),h| h[k] << v }
         .map { |k,v| { k=>v } }
  end
end

def roll()
    (rand(10)).floor + 1
end

def rollNDice(count)
    rolls = []
    (1..count).each do |i|
        rolls.push(roll())
    end
    return rolls
end

def getRollCounts(roll)
    rollCounts = Hash.new 0
    roll.each do |die|
        rollCounts[die] += 1
    end
    return rollCounts
end

# Count all the Tens
def getCritTen(roll)
    critTen = roll.select{|e| e == 10} 
    removedTens = roll.delete_if{|e| e == 10} 

    # return nonTenRoll
    return critTen, removedTens
end
# puts critTen
# Remove the 10's from the roll, and use the subset roll

# Find all permutations of exact Tens
# Start with exact Tens (x+y==10)
# Increase to (x+y=11), etc up to 18 (9+9)
# Loop through remaining roll

def getValidPerms(roll)
    validPerms = []
    (2..(roll.length/2 +1)).each do |i|

        # Loop through permutations starting with 2 (1 perms are perfect 10s)
        roll.combination(i).to_a.each do |j|
            if(j.reduce(:+) >= 10)
                validPerms.push(j)
            end
        end
    end

    return createPermHash(validPerms)
end

def getValidPerms15(roll)
    validPerms = []
    (2..(roll.length/2 +1)).each do |i|

        # Loop through permutations starting with 2 (1 perms are perfect 10s)
        roll.combination(i).to_a.each do |j|
            if(j.reduce(:+) >= 15)
                validPerms.push(j)
            end
        end
    end

    return createPermHash15(validPerms)
end

def createPermHash(validPerms)
    permHash = Hash.new 0
    (10..18).each do |val|
        permHash[val] = (validPerms.select {|e| e.reduce(:+) == val}).uniq
    end
    return permHash
end

def createPermHash15(validPerms)
    permHash = Hash.new 0
    (10..20).each do |val|
        permHash[val] = (validPerms.select {|e| e.reduce(:+) == val}).uniq
    end
    return permHash
end

# Loop through valid perms and decrement the hash value
def calculateRaises(permHash, nonTenRoll, rollCounts)
    finalRoll = []
    permHash.each do |k,v|
        v.each do |i|
            i.each_slice(i.length) do |e|
                if(nonTenRoll.contains_all?(e))
                    finalRoll.push(e) # Push the pair in
                    e.each do |j|
                        next if (rollCounts[j] <= 0)
                        rollCounts[j] -= 1 
                        nonTenRoll.slice!(nonTenRoll.index(j))
                    end
                end
            end
        end
    end

    return finalRoll, nonTenRoll
end

def calculateRaises15(permHash, roll15, rollCounts)
    finalRoll = []
    permHash.each do |k,v|
        v.each do |i|
            i.each_slice(i.length) do |e|
                if(roll15.contains_all?(e))
                    finalRoll.push(e) # Push the pair in
                    e.each do |j|
                        next if (rollCounts[j] <= 0)
                        rollCounts[j] -= 1 
                        roll15.slice!(roll15.index(j))
                    end
                end
            end
        end
    end

    return finalRoll, roll15
end