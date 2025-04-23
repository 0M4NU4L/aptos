module 0xbc93c9b32faa6172550fec69b959f657e42c470b798b6629d2c0ab6ab69ec886::MOOCPlatform {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct representing a course on the platform
    struct Course has store, key {
        fee: u64,              // Enrollment fee in AptosCoin
        enrolled_count: u64,   // Number of students enrolled
    }

    /// Function to create a new course with a specific fee
    public fun create_course(instructor: &signer, fee: u64) {
        let course = Course {
            fee,
            enrolled_count: 0,
        };
        move_to(instructor, course);
    }

    /// Function for students to enroll in a course by paying the fee
    public fun enroll(student: &signer, instructor_address: address) acquires Course {
        let course = borrow_global_mut<Course>(instructor_address);

        let payment = coin::withdraw<AptosCoin>(student, course.fee);
        coin::deposit<AptosCoin>(instructor_address, payment);

        course.enrolled_count = course.enrolled_count + 1;
    }
}