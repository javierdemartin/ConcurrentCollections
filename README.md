# Concurrent Collections

Sample code for mutable collection classes (Array, Dictionary and Set) in multithreaded applications.

Whenever multiple threads share data they must synchronize access to that data to avoid
unexpected behavior when those threads work with the data at the same time.

Working with collection classes in threaded applications locking the object only when
code access its contents may not prevent unexpected behavior.

---------------------

The sample classes in this repository implement some mechanism to guarantee thread safe access to `Collection` classes.

One of the implemented mechanisms to guarantee safe access is to use a concurrent `DispatchQueue`. A concurrent queue allows us to execute multiple tasks at the same time. Tasks will always start in the order they were added but they can finish in a different order as they can be executed in parallel.

To avoid **data races** (multiple-threads accessing the same resource without synchronization and at least one of those accesses is a write operation) we will access that resource using a barrier with `.async(flags: .barrier)`. This will synchronize writes keeping write access synchronized while keeping reads concurrent. A barrier gets in the way of a task and for a brief moment transforms a concurrent queue a serial queue. A task executed with a barrier is delayed until all previously submitted tasks have finished. After the last task is finished the queeu executed the barrier lock and resumes its normal execution behavior.

Read access to the `Collection` is done synchronously (blocks the calling thread until task is over) and writes are asynchronous (returns on the calling thread without blocking).

## Sample Code

* [`ConcurrentDictionary`](ConcurrentDictionary.swift): A thread-safe `Dictionary`

## Resources

Just a list of things I have found interesting while creating these sample pieces:

* [Using collection classes safely with multithreaded applications, 2002](https://developer.apple.com/library/archive/technotes/tn2002/tn2059.html)
