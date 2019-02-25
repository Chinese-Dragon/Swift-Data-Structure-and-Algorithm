import UIKit

/**
 1: Divide and Conquer
 2: Recursive
 3: Stable
 4: Not In-place
    O(n) space because of subarry copies used for merging
 5: Worst case: O(nLogn) time-complexity
*/
func mergeSort<T: Comparable>(_ nums: inout [T]) {
  guard nums.count > 1 else { return }
  
  let mid = nums.count/2
  var left = Array(nums[0..<mid])
  var right = Array(nums[mid...])
  
  mergeSort(&left)
  mergeSort(&right)
  merge(left, right, into: &nums)
}

func merge<T: Comparable>(_ left: [T], _ right: [T], into nums: inout [T]) {
  var kIndex = 0, lIndex = 0, rIndex = 0
  
  while (lIndex < left.count && rIndex < right.count) {
    let curLeftNum = left[lIndex]
    let curRightNum = right[rIndex]
    
    if curLeftNum <= curRightNum {
      nums[kIndex] = curLeftNum
      lIndex += 1
    } else {
      nums[kIndex] = curRightNum
      rIndex += 1
    }
    
    kIndex += 1
  }
  
  while lIndex < left.count {
    nums[kIndex] = left[lIndex]
    lIndex += 1
    kIndex += 1
  }
  
  while rIndex < right.count {
    nums[kIndex] = right[rIndex]
    rIndex += 1
    kIndex += 1
  }
}

var arr = ["c", "a", "d", "z", "m"]
mergeSort(&arr)
print(arr)
