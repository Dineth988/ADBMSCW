SET SERVEROUTPUT ON;

CREATE TABLE Patient (
    patient_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    dob DATE,
    phone VARCHAR(15) CHECK (LENGTH(phone) = 10),
    address VARCHAR(255)
);

-- Create a sequence for auto-incrementing patient_id
CREATE SEQUENCE patient_seq
START WITH 1
INCREMENT BY 1; 

CREATE OR REPLACE TRIGGER patient_id_trigger
BEFORE INSERT ON patient
FOR EACH ROW
BEGIN
    :NEW.patient_id := patient_seq.NEXTVAL;
END;
/

-- Doctor Table
CREATE TABLE Doctor (
    doctor_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    specialization VARCHAR(50),
    phone VARCHAR(15) NOT NULL CHECK (LENGTH(phone) = 10),
    email VARCHAR(100) NOT NULL,
    departmentid INT,
    FOREIGN KEY (departmentid) REFERENCES Departments(departmentid)
);

-- Create a sequence for auto-incrementing doctor_id
CREATE SEQUENCE doctor_seq
START WITH 1
INCREMENT BY 1; 

CREATE OR REPLACE TRIGGER doctor_id_trigger
BEFORE INSERT ON doctor
FOR EACH ROW
BEGIN
    :NEW.doctor_id := doctor_seq.NEXTVAL;
END;
/

-- Appointment Table
CREATE TABLE Appointment (
    appointment_id INT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    appointment_date DATE NOT NULL,
    status VARCHAR(20) CHECK (status IN ('Scheduled', 'Completed', 'Cancelled')),
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctor(doctor_id)
);

-- Create a sequence for auto-incrementing appointment_id
CREATE SEQUENCE appointment_seq
START WITH 1
INCREMENT BY 1; 

CREATE OR REPLACE TRIGGER appointment_id_trigger
BEFORE INSERT ON Appointment
FOR EACH ROW
BEGIN
    :NEW.appointment_id := appointment_seq.NEXTVAL;
END;
/

-- Treatment Table
CREATE TABLE Treatment (
    treatment_id INT PRIMARY KEY,
    appointment_id INT,
    treatment_description VARCHAR(255),
    cost DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (appointment_id) REFERENCES Appointment(appointment_id)
);

-- Create a sequence for auto-incrementing treatment_id
CREATE SEQUENCE treatment_seq
START WITH 1
INCREMENT BY 1; 

CREATE OR REPLACE TRIGGER treatment_id_trigger
BEFORE INSERT ON Treatment
FOR EACH ROW
BEGIN
    :NEW.treatment_id := treatment_seq.NEXTVAL;
END;
/

-- Bill Table
CREATE TABLE Bill (
    bill_id INT PRIMARY KEY,
    patient_id INT,
    total_amount DECIMAL(10, 2) NOT NULL,
    payment_status VARCHAR(20) CHECK (payment_status IN ('Paid', 'Pending')),
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id)
);

-- Create a sequence for auto-incrementing bill_id
CREATE SEQUENCE bill_seq
START WITH 1
INCREMENT BY 1; 

CREATE OR REPLACE TRIGGER bill_id_trigger
BEFORE INSERT ON Bill
FOR EACH ROW
BEGIN
    :NEW.bill_id := bill_seq.NEXTVAL;
END;
/

-- Inventory Table
CREATE TABLE Inventory (
    item_id INT PRIMARY KEY,
    item_name VARCHAR(100) NOT NULL,
    quantity INT CHECK (quantity >= 0),
    price DECIMAL(10, 2) NOT NULL
);

-- Create a sequence for auto-incrementing item_id
CREATE SEQUENCE item_seq
START WITH 1
INCREMENT BY 1; 

CREATE OR REPLACE TRIGGER item_id_trigger
BEFORE INSERT ON Inventory
FOR EACH ROW
BEGIN
    :NEW.item_id := item_seq.NEXTVAL;
END;
/

-- Shift Table
CREATE TABLE Shift (
    shift_id INT PRIMARY KEY,
    doctor_id INT,
    shift_start TIMESTAMP NOT NULL,
    shift_end TIMESTAMP NOT NULL,
    FOREIGN KEY (doctor_id) REFERENCES Doctor(doctor_id)
);

-- Create a sequence for auto-incrementing shift_id
CREATE SEQUENCE shift_seq
START WITH 1
INCREMENT BY 1; 

CREATE OR REPLACE TRIGGER shift_id_trigger
BEFORE INSERT ON Shift
FOR EACH ROW
BEGIN
    :NEW.shift_id := shift_seq.NEXTVAL;
END;
/

-- Medical History Table
CREATE TABLE MedicalHistory (
    history_id INT PRIMARY KEY,
    patient_id INT,
    diagnosis VARCHAR(255),
    treatment VARCHAR(255),
    date_of_entry DATE,
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id)
);

-- Create a sequence for auto-incrementing medHistory_id
CREATE SEQUENCE medHistory_seq
START WITH 1
INCREMENT BY 1; 

CREATE OR REPLACE TRIGGER medHistory_id_trigger
BEFORE INSERT ON MedicalHistory
FOR EACH ROW
BEGIN
    :NEW.History_id := medHistory_seq.NEXTVAL;
END;
/

-- Payment Table
CREATE TABLE Payment (
    payment_id INT PRIMARY KEY,
    bill_id INT,
    payment_method VARCHAR(50) CHECK (payment_method IN ('Cash', 'Card', 'Insurance')),
    payment_date DATE NOT NULL,
    FOREIGN KEY (bill_id) REFERENCES Bill(bill_id)
);

-- Create a sequence for auto-incrementing payment_id
CREATE SEQUENCE payment_seq
START WITH 1
INCREMENT BY 1; 

CREATE OR REPLACE TRIGGER payment_id_trigger
BEFORE INSERT ON Payment
FOR EACH ROW
BEGIN
    :NEW.payment_id := payment_seq.NEXTVAL;
END;
/

-- Department Table
CREATE TABLE Department (
    departmentid INT PRIMARY KEY,
    departmentname VARCHAR(100) NOT NULL
);

-- Create a sequence for auto-incrementing department_id
CREATE SEQUENCE department_seq
START WITH 1
INCREMENT BY 1; 

CREATE OR REPLACE TRIGGER department_id_trigger
BEFORE INSERT ON Departments
FOR EACH ROW
BEGIN
    :NEW.departmentid := department_seq.NEXTVAL;
END;
/

---------------------------------------------------------------PATIENT TABLE-------------------------------------------------------------------------------------

-- Read data from the Patient table
CREATE OR REPLACE PROCEDURE readPatients
AS
BEGIN
    FOR patient IN (SELECT patient_id, name, dob, phone, address FROM Patient)
    LOOP
    dbms_output.put_line(patient.patient_id || ' | ' || patient.name || ' | ' || 
                             TO_CHAR(patient.dob, 'DD-MON-YYYY') || ' | ' || 
                             patient.phone || ' | ' || patient.address);
    END LOOP;
END readPatients;
/

BEGIN
    readPatients;
END;
/

--Insert data into Patient table
CREATE OR REPLACE PROCEDURE createPatient(
                                           pName IN Patient.name%TYPE,
                                           pDOB IN Patient.dob%TYPE,
                                           pPhone IN Patient.phone%TYPE,
                                           pAddress IN Patient.address%TYPE)
AS
BEGIN
     INSERT INTO Patient ( name, dob, phone, address)
    VALUES ( pName, pDOB, pPhone, pAddress);
    dbms_output.put_line('Patient Added');
END createPatient;
/
    
BEGIN
    createPatient( 'Dineth', TO_DATE('1985-06-15', 'YYYY-MM-DD'), '1234567890', '123 Main St, City C');
END;
/

--Update data of Patient table
CREATE OR REPLACE PROCEDURE updatePatient(pID IN Patient.patient_id%TYPE,
                                           pName IN Patient.name%TYPE,
                                           pDOB IN Patient.dob%TYPE,
                                           pPhone IN Patient.phone%TYPE,
                                           pAddress IN Patient.address%TYPE)
AS
BEGIN
    UPDATE Patient
    SET Patient.name = pName, Patient.dob = pDOB, Patient.phone = pPhone, Patient.address = pAddress
    WHERE patient_id = pID;
    DBMS_OUTPUT.PUT_LINE('Patient Updated Successfully');
END updatePatient;
/

BEGIN
    updatePatient(3, 'Dineth', TO_DATE('2002-05-08', 'YYYY-MM-DD'), '1234567890', '124 Main St, City D');
END;
/

--Delete patient
CREATE OR REPLACE PROCEDURE deletePatient (pID IN Patient.patient_id%TYPE)
AS
BEGIN
    DELETE Patient WHERE Patient.patient_id=pID;
    DBMS_OUTPUT.PUT_LINE('Patient Deleted Successfully');
END deletePatient;
/

BEGIN
    deletePatient(3);
END;
/
---------------------------------------------------------------DOCTOR TABLE-------------------------------------------------------------------------------------
-- Insert data into Doctor table
CREATE OR REPLACE PROCEDURE createDoctor(
                                        dID IN Doctor.doctor_id%TYPE,
                                        dName IN Doctor.name%TYPE,
                                        dSpecialization IN Doctor.specialization%TYPE,
                                        dPhone IN Doctor.phone%TYPE,
                                        dEmail IN Doctor.email%TYPE,
                                        dDepartmentId IN Doctor.departmentId%TYPE
)
AS
BEGIN
    INSERT INTO Doctor (doctor_id, name, specialization, phone, email, departmentid)
    VALUES (dID, dName, dSpecialization, dPhone, dEmail, dDepartmentId);
    
    DBMS_OUTPUT.PUT_LINE('Doctor Added');
END createDoctor;
/

-- Read data from the Doctor table
CREATE OR REPLACE PROCEDURE readDoctors
AS
BEGIN
    FOR doctor IN (
        SELECT d.doctor_id, d.name, d.specialization, d.phone, d.email, dep.departmentName
        FROM Doctor d
        JOIN departments dep ON d.departmentid = dep.departmentid
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE(doctor.doctor_id || ' | ' || doctor.name || ' | ' ||
                             doctor.specialization || ' | ' || doctor.phone || ' | ' ||
                             doctor.email || ' | ' || doctor.departmentName);
    END LOOP;
END readDoctors;
/


BEGIN
    readDoctors;
END;
/

-- Get doctors by id or specialization

CREATE OR REPLACE PROCEDURE getDoctorInfo (
    p_doctor_id IN Doctor.doctor_id%TYPE DEFAULT NULL,
    p_specialization IN Doctor.specialization%TYPE DEFAULT NULL
)
AS
    v_doctor_id Doctor.doctor_id%TYPE;
    v_name Doctor.name%TYPE;
    v_specialization Doctor.specialization%TYPE;
    v_phone Doctor.phone%TYPE;
    v_email Doctor.email%TYPE;
    v_departmentName departments.departmentName%TYPE;
BEGIN
    IF p_doctor_id IS NOT NULL THEN
        SELECT d.doctor_id, d.name, d.specialization, d.phone, d.email, dep.departmentName
        INTO v_doctor_id, v_name, v_specialization, v_phone, v_email, v_departmentName
        FROM Doctor d
        JOIN departments dep ON d.departmentid = dep.departmentid
        WHERE d.doctor_id = p_doctor_id;
        DBMS_OUTPUT.PUT_LINE(v_doctor_id || ' | ' || v_name || ' | ' || v_specialization || ' | ' || v_phone || ' | ' || v_email || ' | ' || v_departmentName);

    ELSIF p_specialization IS NOT NULL THEN
        FOR doctor IN (
            SELECT d.doctor_id, d.name, d.specialization, d.phone, d.email, dep.departmentName
            FROM Doctor d
            JOIN departments dep ON d.departmentid = dep.departmentid
            WHERE d.specialization = p_specialization
        )
        LOOP
            DBMS_OUTPUT.PUT_LINE(doctor.doctor_id || ' | ' || doctor.name || ' | ' || doctor.specialization || ' | ' || doctor.phone || ' | ' || doctor.email || ' | ' || doctor.departmentName);
        END LOOP;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Please provide either a doctor ID or a specialization.');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No doctor found with the given info.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END getDoctorInfo;
/

-- Delete Doctor
CREATE OR REPLACE PROCEDURE deleteDoctor(docId IN Doctor.Doctor_Id%TYPE)
AS
BEGIN 
    DELETE Doctor WHERE Doctor.Doctor_id=docId;
END deleteDoctor;
/
--Update Doctor
CREATE OR REPLACE PROCEDURE updateDoctor( dID IN Doctor.doctor_id%TYPE,
                                          dName IN Doctor.name%TYPE,
                                          dSpecialization IN Doctor.specialization%TYPE,
                                          dPhone IN Doctor.phone%TYPE,
                                          dEmail IN Doctor.email%TYPE,
                                          dDepartmentId IN Doctor.departmentId%TYPE)
AS
BEGIN 
    UPDATE Doctor 
    SET Doctor.name=dName, Doctor.specialization=dSpecialization, Doctor.phone=dPhone, Doctor.email=dEmail, Doctor.departmentid=dDepartmentId
    WHERE Doctor.doctor_id=dId;
END updateDoctor;
/

---------------------------------------------------------------APPOINTMENT TABLE-----------------------------------------------------------------------------------------

-- Shedule a Appointment
CREATE OR REPLACE PROCEDURE scheduleAppointment (
                                                pName IN Patient.name%TYPE,
                                                dName IN Doctor.name%TYPE,
                                                aDate IN Appointment.appointment_date%TYPE,
                                                aStatus IN Appointment.status%TYPE DEFAULT 'Scheduled'
)
AS
    patientId Patient.patient_id%TYPE;
    doctorId Doctor.doctor_id%TYPE;
BEGIN
    SELECT patient_id
    INTO patientId
    FROM Patient
    WHERE name = pName;

    SELECT doctor_id
    INTO doctorId
    FROM Doctor
    WHERE name = dName;

    INSERT INTO Appointment (patient_id, doctor_id, appointment_date, status)
    VALUES (patientId, doctorId, aDate, aStatus);

    DBMS_OUTPUT.PUT_LINE('Appointment scheduled successfully for patient: ' || pName || ' with doctor: ' || dName);
EXCEPTION

    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: No matching patient or doctor found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END scheduleAppointment;
/

-- Update Appointment Status
CREATE OR REPLACE PROCEDURE updateAppointmentStatus(aId IN Appointment.appointment_id%TYPE,
                                                    aStatus IN Appointment.status%TYPE)
AS
BEGIN
    UPDATE Appointment
    SET Appointment.Status=aStatus
    WHERE Appointment.appointment_id=aId;
END updateAppointmentStatus;
/

--Get appointment by patient name
CREATE OR REPLACE PROCEDURE getAppointmentByPname(pName IN Patient.name%TYPE)
AS
    CURSOR appointment_cursor IS
        SELECT p.name AS patient_name, 
               d.name AS doctor_name, 
               d.specialization, 
               d.phone, 
               d.email
        FROM Appointment a
        JOIN Patient p ON a.patient_id = p.patient_id
        JOIN Doctor d ON a.doctor_id = d.doctor_id
        WHERE p.name = pName;  

    patientName Patient.name%TYPE;
    doctorName Doctor.name%TYPE;
    dspecialization Doctor.specialization%TYPE;
    dphone Doctor.phone%TYPE;
    demail Doctor.email%TYPE;
BEGIN
    OPEN appointment_cursor;
    LOOP
        FETCH appointment_cursor INTO patientName, doctorName, dspecialization, dphone, demail;
        EXIT WHEN appointment_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('Patient Name: ' || patientName || 
                             ', Doctor Name: ' || doctorName || 
                             ', Specialization: ' || dspecialization || 
                             ', Phone: ' || dphone || 
                             ', Email: ' || demail);
    END LOOP;
    CLOSE appointment_cursor;
END getAppointmentByPname;
/

-- Get appointment by Doctor name
CREATE OR REPLACE PROCEDURE getAppointmentByDname(dName IN Doctor.name%TYPE)
AS
    CURSOR appointment_cursor IS
        SELECT p.name AS patient_name, 
               d.name AS doctor_name, 
               a.status AS appointment_status, 
               a.appointment_date AS appointment_timestamp
        FROM Appointment a
        JOIN Patient p ON a.patient_id = p.patient_id
        JOIN Doctor d ON a.doctor_id = d.doctor_id
        WHERE d.name = dName; 

    patientName Patient.name%TYPE;
    doctorName Doctor.name%TYPE;
    appointmentStatus Appointment.status%TYPE;
    appointmentTimestamp Appointment.appointment_date%TYPE;
BEGIN
    OPEN appointment_cursor;
    LOOP
        FETCH appointment_cursor INTO patientName, doctorName, appointmentStatus, appointmentTimestamp;
        EXIT WHEN appointment_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Doctor Name: ' || doctorName ||
                             ',Patient Name: ' || patientName ||                
                             ', Status: ' || appointmentStatus || 
                             ', Timestamp: ' || TO_CHAR(appointmentTimestamp, 'YYYY-MM-DD HH24:MI:SS'));
    END LOOP;
    CLOSE appointment_cursor;
END getAppointmentByDname;
/

-- Delete Appointment
CREATE OR REPLACE PROCEDURE cancelAppointment(aId IN Appointment.appointment_id%TYPE)
AS
BEGIN
    DELETE Appointment WHERE Appointment.appointment_id=aId;
    
END cancelAppointment;
/

---------------------------------------------------------------TREATMENT TABLE-----------------------------------------------------------------------------------

-- Add treatment
CREATE OR REPLACE PROCEDURE addTreatment(aId IN Treatment.appointment_id%TYPE,
                               treatmentDes IN Treatment.treatment_description%TYPE, 
                               tCost IN Treatment.cost%TYPE)
AS
BEGIN
    INSERT INTO Treatment (Appointment_id, Treatment_description, Cost)
    VALUES (aId, treatmentDes, tCost);
     dbms_output.put_line('Treatment Added');
END addTreatment;
/

-- Get Treatment by Appointment ID
CREATE OR REPLACE PROCEDURE getTreatmentById(aId IN Treatment.appointment_id%TYPE)
AS
BEGIN
    FOR rec IN (SELECT treatment_id, treatment_description, cost 
                FROM Treatment 
                WHERE appointment_id = aId)
    LOOP
        dbms_output.put_line('Treatment ID: ' || rec.treatment_id || 
                             ' | Description: ' || rec.treatment_description || 
                             ' | Cost: ' || rec.cost);
    END LOOP;
END getTreatmentById;
/

-- DELETE TREATMENT
CREATE OR REPLACE PROCEDURE deleteTreatment(tId IN Treatment.Treatment_id%TYPE)
AS
BEGIN
    DELETE Treatment WHERE Treatment_id=tId;
    dbms_output.put_line('Treatment Deleted');
END deleteTreatment;
/

--------------------------------------------------------------BILL TABLE--------------------------------------------------------------------------------------

-- GENERATE BILL
CREATE OR REPLACE PROCEDURE generateBill(pName IN Patient.name%TYPE)
AS
    patientId Patient.patient_id%TYPE;
    totalCost DECIMAL(10, 2) := 0;
    doctorCharge DECIMAL(10, 2) := 1500; 
BEGIN
    SELECT patient_id
    INTO patientId
    FROM Patient
    WHERE name = pName;
    
    FOR treatment_rec IN (
        SELECT t.treatment_description, 
               t.cost,
               'Pending' AS status,  
               d.name AS doctor_name  
        FROM Treatment t
        JOIN Appointment a ON t.appointment_id = a.appointment_id
        JOIN Doctor d ON a.doctor_id = d.doctor_id 
        WHERE a.patient_id = patientId
    ) LOOP
        totalCost := totalCost + treatment_rec.cost; 
        dbms_output.put_line('Patient Name: ' || pName || 
                             ' | Treatment: ' || treatment_rec.treatment_description || 
                             ' | Cost: ' || treatment_rec.cost || 
                             ' | Doctor: ' || treatment_rec.doctor_name || 
                             ' | Status: ' || treatment_rec.status);
    END LOOP;
    totalCost := totalCost + doctorCharge;
    dbms_output.put_line('Total Bill for Patient: ' || pName || 
                         ' | Total Treatment Cost: ' || (totalCost - doctorCharge) ||
                         ' | Doctor Charge: ' || doctorCharge ||
                         ' | Total Cost: ' || totalCost);
     
    INSERT INTO Bill (patient_id, total_amount, payment_status)
    VALUES (patientId, totalCost, 'Pending');                    
                         
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('No patient found with the name: ' || pName);
    WHEN OTHERS THEN
        dbms_output.put_line('An error occurred: ' || SQLERRM);
END generateBill;
/

-- UPDATE BILL STATUS
CREATE OR REPLACE PROCEDURE updateStatus(bId IN bill.bill_id%TYPE,
                                         bStatus IN bill.payment_status%TYPE)
AS
BEGIN 
    UPDATE Bill
    SET Bill.payment_status=bStatus
    WHERE Bill_ID=bId;
END updateStatus;
/

-- Retrieve bill by patient id
CREATE OR REPLACE PROCEDURE getBillByPatient(
                                             pID IN Bill.patient_id%TYPE
)
AS
BEGIN
    FOR bill IN (SELECT * FROM Bill WHERE patient_id = pID)
    LOOP
        DBMS_OUTPUT.PUT_LINE(bill.bill_id || ' | ' || bill.total_amount || ' | ' || bill.payment_status);
    END LOOP;
END getBillByPatient;
/

------------------------------------------------------------PAYMENT TABLE---------------------------------------------------------------------------------------

-- Payment
CREATE OR REPLACE PROCEDURE pay(
    bId IN Payment.bill_id%TYPE,
    paymentMethod IN Payment.payment_method%TYPE,
    pAmount IN Payment.amount%TYPE
) AS
    paymentDate DATE := SYSDATE;  
    billTotal DECIMAL(10, 2); 
    billRemain DECIMAL(10, 2); 
BEGIN
    SELECT Bill.total_amount 
    INTO billTotal
    FROM Bill 
    WHERE Bill.bill_id = bId;

    billRemain := billTotal - pAmount;

    UPDATE Bill
    SET total_amount = billRemain
    WHERE bill_id = bId;

    INSERT INTO Payment (bill_id, payment_method, payment_date, amount)
    VALUES (bId, paymentMethod, paymentDate, pAmount);

    DBMS_OUTPUT.PUT_LINE('Payment recorded for Bill ID: ' || bId || 
                         ' | Amount: ' || pAmount || 
                         ' | Method: ' || paymentMethod || 
                         ' | Date: ' || TO_CHAR(paymentDate, 'DD-MON-YYYY') || 
                         ' | Total Bill Remaining: ' || billRemain);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No bill found with ID: ' || bId);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END pay;
/

-- Show outstanding amount
CREATE OR REPLACE PROCEDURE showOutstandingAmount(bId IN Payment.bill_id%TYPE)
AS
    pId Patient.patient_id%TYPE;
    pName Patient.name%TYPE;
    bTotal Bill.total_amount%TYPE;
BEGIN
    SELECT patient_id, total_amount 
    INTO pId, bTotal
    FROM Bill
    WHERE bill_id = bId;

    SELECT name 
    INTO pName
    FROM Patient
    WHERE patient_id = pId;

    DBMS_OUTPUT.PUT_LINE('Patient ID: ' || pId || 
                         ' | Patient Name: ' || pName || 
                         ' | Outstanding Bill Amount: ' || bTotal);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No bill found with ID: ' || bId);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END showOutstandingAmount;
/

------------------------------------------------------------INVENTORY TABLE--------------------------------------------------------------------------------------------

-- Add new items
CREATE OR REPLACE PROCEDURE addNewItem(
    pItemName IN Inventory.item_name%TYPE,
    pQuantity IN Inventory.quantity%TYPE,
    pPrice IN Inventory.price%TYPE
) AS
BEGIN
    INSERT INTO Inventory (item_name, quantity, price)
    VALUES (pItemName, pQuantity, pPrice);
    
    DBMS_OUTPUT.PUT_LINE('Item added: ' || pItemName || 
                         ' | Quantity: ' || pQuantity || 
                         ' | Price: ' || pPrice);
END addNewItem;
/

-- Update item
CREATE OR REPLACE PROCEDURE updateItemQuantity(
    pItemId IN Inventory.item_id%TYPE,
    pQuantity IN Inventory.quantity%TYPE
) AS
    newQuantity Inventory.quantity%TYPE;  
BEGIN
    UPDATE Inventory
    SET quantity = quantity + pQuantity
    WHERE item_id = pItemId;

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No item found with ID: ' || pItemId);
    ELSE
        SELECT quantity INTO newQuantity FROM Inventory WHERE item_id = pItemId;
        DBMS_OUTPUT.PUT_LINE('Item ID: ' || pItemId || 
                             ' | New Quantity: ' || newQuantity);
    END IF;
END updateItemQuantity;
/

-- Track item usage
CREATE OR REPLACE PROCEDURE useItem(
    pItemId IN Inventory.item_id%TYPE,
    pQuantity IN Inventory.quantity%TYPE
) AS
    currentQuantity Inventory.quantity%TYPE;
BEGIN
    SELECT quantity INTO currentQuantity FROM Inventory WHERE item_id = pItemId;
    IF currentQuantity < pQuantity THEN
        DBMS_OUTPUT.PUT_LINE('Insufficient quantity for item ID: ' || pItemId);
    ELSE
        UPDATE Inventory
        SET quantity = quantity - pQuantity
        WHERE item_id = pItemId;

        DBMS_OUTPUT.PUT_LINE('Item ID: ' || pItemId || 
                             ' | Quantity Used: ' || pQuantity ||
                             ' | Remaining Quantity: ' || (currentQuantity - pQuantity));
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No item found with ID: ' || pItemId);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END useItem;
/

------------------------------------------------------------SHIFT TABLE-------------------------------------------------------------------------------------

-- Assign shift
CREATE OR REPLACE PROCEDURE assignShift(
    shiftData IN Shift%ROWTYPE
) AS
BEGIN
    INSERT INTO Shift (doctor_id, shift_start, shift_end)
    VALUES (shiftData.doctor_id, shiftData.shift_start, shiftData.shift_end);

    DBMS_OUTPUT.PUT_LINE('Shift assigned for Doctor ID: ' || shiftData.doctor_id ||
                         ' | Shift Start: ' || TO_CHAR(shiftData.shift_start, 'DD-MON-YYYY HH24:MI:SS') ||
                         ' | Shift End: ' || TO_CHAR(shiftData.shift_end, 'DD-MON-YYYY HH24:MI:SS'));
END assignShift;
/


--Update shift
CREATE OR REPLACE PROCEDURE updateShift(
    shiftId IN Shift.shift_id%TYPE,
    updatedData IN Shift%ROWTYPE
) AS
BEGIN
    UPDATE Shift
    SET doctor_id = updatedData.doctor_id,
        shift_start = updatedData.shift_start,
        shift_end = updatedData.shift_end
    WHERE shift_id = shiftId;

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No shift found with ID: ' || shiftId);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Shift updated for Shift ID: ' || shiftId);
    END IF;
END updateShift;
/

-- Show shift by doctor name
CREATE OR REPLACE PROCEDURE getShiftsByDoctorName(
    doctorName IN Doctor.name%TYPE
)
AS
BEGIN
    FOR rec IN (
        SELECT s.shift_id, 
               s.doctor_id, 
               s.shift_start, 
               s.shift_end
        FROM Shift s
        JOIN Doctor d ON s.doctor_id = d.doctor_id
        WHERE d.name = doctorName
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Shift ID: ' || rec.shift_id || 
                             ' | Doctor ID: ' || rec.doctor_id || 
                             ' | Shift Start: ' || TO_CHAR(rec.shift_start, 'DD-MON-YYYY HH24:MI:SS') || 
                             ' | Shift End: ' || TO_CHAR(rec.shift_end, 'DD-MON-YYYY HH24:MI:SS'));
    END LOOP;
END getShiftsByDoctorName;
/


-- Get shift by date range
CREATE OR REPLACE PROCEDURE getShiftsByDateRange(
    startDate IN TIMESTAMP,
    endDate IN TIMESTAMP
) 
AS
BEGIN
    FOR rec IN (
        SELECT s.shift_id, 
               s.doctor_id, 
               s.shift_start, 
               s.shift_end, 
               d.name AS doctor_name, 
               d.phone_number
        FROM Shift s
        JOIN Doctor d ON s.doctor_id = d.doctor_id
        WHERE s.shift_start >= startDate AND s.shift_end <= endDate
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Shift ID: ' || rec.shift_id || 
                             ' | Doctor ID: ' || rec.doctor_id || 
                             ' | Doctor Name: ' || rec.doctor_name || 
                             ' | Phone Number: ' || rec.phone_number ||
                             ' | Shift Start: ' || TO_CHAR(rec.shift_start, 'DD-MON-YYYY HH24:MI:SS') || 
                             ' | Shift End: ' || TO_CHAR(rec.shift_end, 'DD-MON-YYYY HH24:MI:SS'));
    END LOOP;
END getShiftsByDateRange;
/

-----------------------------------------------------------MEDICAL HISTORY TABLE---------------------------------------------------------------------------------


-- Add info
CREATE OR REPLACE PROCEDURE addMedicalHistory(
    pHistoryId IN MedicalHistory.history_id%TYPE,
    pPatientId IN MedicalHistory.patient_id%TYPE,
    pDiagnosis IN MedicalHistory.diagnosis%TYPE,
    pTreatment IN MedicalHistory.treatment%TYPE,
    pDateOfEntry IN MedicalHistory.date_of_entry%TYPE
) AS
BEGIN
    INSERT INTO MedicalHistory (history_id, patient_id, diagnosis, treatment, date_of_entry)
    VALUES (pHistoryId, pPatientId, pDiagnosis, pTreatment, pDateOfEntry);

    DBMS_OUTPUT.PUT_LINE('Medical history added for Patient ID: ' || pPatientId);
END addMedicalHistory;
/

-- Update info
CREATE OR REPLACE PROCEDURE updateMedicalHistory(
    pHistoryId IN MedicalHistory.history_id%TYPE,
    pPatientId IN MedicalHistory.patient_id%TYPE,
    pDiagnosis IN MedicalHistory.diagnosis%TYPE,
    pTreatment IN MedicalHistory.treatment%TYPE,
    pDateOfEntry IN MedicalHistory.date_of_entry%TYPE
) AS
BEGIN
    UPDATE MedicalHistory
    SET patient_id = pPatientId,
        diagnosis = pDiagnosis,
        treatment = pTreatment,
        date_of_entry = pDateOfEntry
    WHERE history_id = pHistoryId;

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No medical history found with ID: ' || pHistoryId);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Medical history updated for ID: ' || pHistoryId);
    END IF;
END updateMedicalHistory;
/

-- Get history info by id
CREATE OR REPLACE PROCEDURE getMedicalHistoryByPatient(
    pPatientId IN MedicalHistory.patient_id%TYPE
) AS
BEGIN
    FOR rec IN (
        SELECT * FROM MedicalHistory 
        WHERE patient_id = pPatientId
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('History ID: ' || rec.history_id || 
                             ' | Patient ID: ' || rec.patient_id || 
                             ' | Diagnosis: ' || rec.diagnosis || 
                             ' | Treatment: ' || rec.treatment || 
                             ' | Date of Entry: ' || TO_CHAR(rec.date_of_entry, 'DD-MON-YYYY'));
    END LOOP;
END getMedicalHistoryByPatient;
/

-- Delete info
CREATE OR REPLACE PROCEDURE deleteMedicalHistoryByPatient(
    pPatientId IN MedicalHistory.patient_id%TYPE
) AS
BEGIN
    DELETE FROM MedicalHistory
    WHERE patient_id = pPatientId;

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No medical history found for Patient ID: ' || pPatientId);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Medical history deleted for Patient ID: ' || pPatientId);
    END IF;
END deleteMedicalHistoryByPatient;
/


----------------------------------------------------------DEPAERTMENT TABLE--------------------------------------------------------------------------------------

-- Create department
CREATE OR REPLACE PROCEDURE addDepartment(
    departmentData IN Departments.departmentname%TYPE
) AS
BEGIN
    INSERT INTO Departments (departmentid, departmentname)
    VALUES (Department_seq.NEXTVAL, departmentData); -- Assuming you have a sequence `Department_seq` for generating department IDs

    DBMS_OUTPUT.PUT_LINE('Department added: ' || departmentData);
END addDepartment;
/

-- Update department
CREATE OR REPLACE PROCEDURE updateDepartment(
    departmentId IN Departments.departmentid%TYPE,
    updatedData IN Departments.departmentname%TYPE
) AS
BEGIN
    UPDATE Departments
    SET departmentname = updatedData
    WHERE departmentid = departmentId;

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No department found with ID: ' || departmentId);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Department ID ' || departmentId || ' updated to ' || updatedData);
    END IF;
END updateDepartment;
/

-- Display departments
CREATE OR REPLACE PROCEDURE getDepartment(
    departmentId IN Departments.departmentid%TYPE
) AS
    deptName Departments.departmentname%TYPE;
BEGIN
    SELECT departmentname INTO deptName
    FROM Departments
    WHERE departmentid = departmentId;

    DBMS_OUTPUT.PUT_LINE('Department ID: ' || departmentId || ' | Department Name: ' || deptName);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No department found with ID: ' || departmentId);
END getDepartment;
/

-- Delete department
CREATE OR REPLACE PROCEDURE deleteDepartment(
    departmentId IN Departments.departmentid%TYPE
) AS
BEGIN
    DELETE FROM Departments
    WHERE departmentid = departmentId;

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No department found with ID: ' || departmentId);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Department with ID ' || departmentId || ' has been deleted.');
    END IF;
END deleteDepartment;
/

----------------------------------------------------------REPORTS------------------------------------------------------------------------------------------------

-- Doctor appointment load report
CREATE OR REPLACE PROCEDURE doctor_appointment_load_report(startDate IN DATE, endDate IN DATE) IS
BEGIN
  DBMS_OUTPUT.PUT_LINE('--- Doctor Appointment Load Report ---');
  FOR rec IN (SELECT d.name AS doctor_name, COUNT(a.appointment_id) AS total_appointments
              FROM Doctor d
              JOIN Appointment a ON d.doctor_id = a.doctor_id
              WHERE a.appointment_date BETWEEN startDate AND endDate
              GROUP BY d.name) LOOP
    IF rec.total_appointments > 50 THEN
      DBMS_OUTPUT.PUT_LINE('Doctor: ' || rec.doctor_name || ' | Appointments: ' || rec.total_appointments || ' | Status: High Load');
    ELSE
      DBMS_OUTPUT.PUT_LINE('Doctor: ' || rec.doctor_name || ' | Appointments: ' || rec.total_appointments || ' | Status: Manageable Load');
    END IF;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('------------------------------------');
END;
/


-- Inventory stock report
CREATE OR REPLACE PROCEDURE inventory_stock_report IS
BEGIN
  DBMS_OUTPUT.PUT_LINE('--- Inventory Stock Report ---');
  FOR rec IN (SELECT item_name, quantity
              FROM Inventory
              WHERE quantity < 10
              ORDER BY quantity ASC) LOOP
    DBMS_OUTPUT.PUT_LINE('Item: ' || rec.item_name || ' | Remaining Stock: ' || rec.quantity || ' | Status: Low Stock');
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('-------------------------------');
END;
/


-- Treatment cost report
CREATE OR REPLACE PROCEDURE treatment_cost_report(startDate IN DATE, endDate IN DATE) IS
BEGIN
  DBMS_OUTPUT.PUT_LINE('--- Treatment Cost Report ---');
  FOR rec IN (SELECT p.name AS patient_name, SUM(t.cost) AS total_cost
              FROM Patient p
              JOIN Appointment a ON p.patient_id = a.patient_id
              JOIN Treatment t ON a.appointment_id = t.appointment_id
              WHERE a.appointment_date BETWEEN startDate AND endDate
              GROUP BY p.name) LOOP
    IF rec.total_cost > 10000 THEN
      DBMS_OUTPUT.PUT_LINE('Patient: ' || rec.patient_name || ' | Treatment Cost: $' || rec.total_cost || ' | Status: High Cost');
    ELSE
      DBMS_OUTPUT.PUT_LINE('Patient: ' || rec.patient_name || ' | Treatment Cost: $' || rec.total_cost || ' | Status: Moderate Cost');
    END IF;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('--------------------------------');
END;
/

-- Doctor appointments by specialization
CREATE OR REPLACE PROCEDURE doctor_appointment_specialization_report(startDate IN DATE, endDate IN DATE) IS
BEGIN
  DBMS_OUTPUT.PUT_LINE('--- Doctor Appointment Summary by Specialization ---');
  FOR rec IN (SELECT d.specialization, 
                     COUNT(a.appointment_id) AS total_appointments,
                     SUM(CASE WHEN a.status = 'Completed' THEN 1 ELSE 0 END) AS completed_appointments,
                     SUM(CASE WHEN a.status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_appointments
              FROM Doctor d
              JOIN Appointment a ON d.doctor_id = a.doctor_id
              WHERE a.appointment_date BETWEEN startDate AND endDate
              AND (d.specialization LIKE 'Cardiologist%' OR d.specialization LIKE 'Dermatologist%')
              GROUP BY d.specialization
              HAVING COUNT(a.appointment_id) > 5
              ORDER BY total_appointments DESC) LOOP
    DBMS_OUTPUT.PUT_LINE('Specialization: ' || rec.specialization || ' | Total Appointments: ' || rec.total_appointments || 
                         ' | Completed: ' || rec.completed_appointments || ' | Cancelled: ' || rec.cancelled_appointments);
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('--------------------------------------------------');
END;
/

-- Doctor performance report
CREATE OR REPLACE PROCEDURE doctor_performance_report(startDate IN DATE, endDate IN DATE) IS
BEGIN
  DBMS_OUTPUT.PUT_LINE('--- Doctor Performance Report ---');
  FOR rec IN (SELECT d.name AS doctor_name, 
                     COUNT(a.appointment_id) AS total_patients, 
                     SUM(t.cost) AS total_revenue,
                     CASE 
                       WHEN SUM(t.cost) > 50000 THEN 'Top Performer'
                       WHEN SUM(t.cost) BETWEEN 30000 AND 50000 THEN 'Average Performer'
                       ELSE 'Low Performer'
                     END AS performance_category
              FROM Doctor d
              JOIN Appointment a ON d.doctor_id = a.doctor_id
              JOIN Treatment t ON a.appointment_id = t.appointment_id
              WHERE a.appointment_date BETWEEN startDate AND endDate
              GROUP BY d.name
              HAVING COUNT(a.appointment_id) > 5
              ORDER BY SUM(t.cost) DESC) LOOP
    DBMS_OUTPUT.PUT_LINE('Doctor: ' || rec.doctor_name || ' | Patients: ' || rec.total_patients || ' | Revenue: $' || rec.total_revenue || ' | Performance: ' || rec.performance_category);
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('----------------------------------------------');
END;
/

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
BEGIN
   doctor_appointment_load_report(
      TO_DATE('2024-10-15', 'YYYY-MM-DD'), 
      TO_DATE('2024-10-16', 'YYYY-MM-DD')
   ); 
END;
/

BEGIN
  inventory_stock_report;
END;
/

BEGIN
   treatment_cost_report(
      TO_DATE('2024-10-01', 'YYYY-MM-DD'),  -- Start Date
      TO_DATE('2024-10-31', 'YYYY-MM-DD')   -- End Date
   ); 
END;
/

BEGIN
   doctor_appointment_specialization_report(
      TO_DATE('2024-10-01', 'YYYY-MM-DD'),  -- Start Date
      TO_DATE('2024-10-31', 'YYYY-MM-DD')   -- End Date
   );
END;
/

BEGIN
   doctor_performance_report(
      TO_DATE('2024-10-01', 'YYYY-MM-DD'),  -- Start Date
      TO_DATE('2024-10-31', 'YYYY-MM-DD')   -- End Date
   );
END;
/

