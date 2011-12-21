require 'thread'
module Guise
  module Cross
    extend self
    
    def validate(prob, param, fold = 5)
      total_correct = 0
      
      target = new_double(prob.l)
      svm_cross_validation(prob, param, fold, target)
      
      (0...prob.l).each do |i|
    	  if double_getitem(target, i) == double_getitem(prob.y, i)
    	    total_correct += 1
          # puts "Cross Validation Accuracy = #{100.0 * total_correct / prob.l}"
  	    end
	    end
	    delete_double(target)
	    (100.0 * total_correct / prob.l)
    end
    
    def optimize(training)
      seed = [8.0, 2] # Gamma denominator and Cost
      puts "Getting initial accuracy"
      accuracy = validate(training.problem.prob, SVM::Parameter.new(:kernel_type => RBF, :gamma => 1 / seed.first, :C => seed[1]).param)
      puts accuracy
      best_solution = local_minima(training, seed, accuracy, [seed])
      SVM::Parameter.new(:gamma => 1 / best_solution.first, :C => best_solution[1])
    end
    
    def local_minima(training, seed, accuracy, visited, iter = 0)
      val = lambda do |g, c|
        validate(training.problem.prob, SVM::Parameter.new(:kernel_type => RBF, :gamma => 1 / g, :C => c).param)
      end
      
      
      north_west  = [seed[0] - 1, seed[1] + 1]
      west        = [seed[0] - 1, seed[1]]
      south_west  = [seed[0] - 1, seed[1] - 1]
      south       = [seed[0], seed[1] - 1]
      south_east  = [seed[0] + 1, seed[1] - 1]
      east        = [seed[0] + 1, seed[1]]
      north_east  = [seed[0] + 1, seed[1] + 1]
      north       = [seed[0], seed[1] + 1]
      
      [north_west, west, south_west, south, south_east, east, north_east, north].each do |direction|
        puts "Moving to #{direction.inspect}"
        unless visited.include?(direction)
          new_accuracy = val.call(*direction)
          visited << direction
          if (new_accuracy - accuracy) > 1 && iter < 20
            puts "found a better solution at #{direction}: #{new_accuracy}"
            local_minima(training, direction, new_accuracy, visited, iter + 1)
            break
          elsif iter == 20
            return seed # Best solution so far
          end
        end
      end
      seed
      
    end
  end
end