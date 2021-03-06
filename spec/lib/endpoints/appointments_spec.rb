require 'spec_helper'

describe AthenaHealth::Endpoints::Appointments do
  describe '#open_appointment_slots' do
    let(:attributes) do
      {
        practice_id: 195_900,
        department_id: 1,
        provider_id: 71,
        params: { reasonid: 563 }
      }
    end

    it 'returns instance of AppointmentCollection' do
      VCR.use_cassette('open_appointment_slots') do
        expect(client.open_appointment_slots(attributes))
          .to be_an_instance_of AthenaHealth::AppointmentCollection
      end
    end
  end

  describe '#book_appointment' do
    context 'with wrong appointment id' do
      let(:attributes) do
        {
          practice_id: 195_900,
          appointment_id: 665839,
          patient_id: 1,
          params: { reasonid: 563 }
        }
      end

      it 'raise AthenaHealth::ValidationError error' do
        VCR.use_cassette('book_appointment_with_wrong_appointment_id') do
          expect { client.book_appointment(attributes) }.to raise_error { |error|
            expect(error).to be_a(AthenaHealth::ValidationError)
            expect(error.details).to eq(
              {
                'detailedmessage' => 'The appointment ID is already booked or is not marked as being available to be scheduled via the API.',
                'error' => 'That appointment time was already booked or not available for booking.'
              }
            )
          }
        end
      end
    end

    context 'with correct data' do
      let(:attributes) do
        {
          practice_id: 195_900,
          appointment_id: 659324,
          patient_id: 1,
          params: { appointmenttypeid: 82 }
        }
      end

      it 'returns instance of Appointment' do
        VCR.use_cassette('book_appointment') do
         expect(client.book_appointment(attributes))
          .to be_an_instance_of AthenaHealth::Appointment
        end
      end
    end
  end

  describe '#all_patient_appointment_reasons' do
    let(:attributes) do
      {
        practice_id: 195_900,
        department_id: 1,
        provider_id: 1
      }
    end

    it 'returns instance of PatientAppointmentReasonCollection' do
      VCR.use_cassette('patient_appointment_reasons') do
        expect(client.all_patient_appointment_reasons(attributes))
          .to be_an_instance_of AthenaHealth::PatientAppointmentReasonCollection
      end
    end
  end

  describe '#booked_appointments' do
    let(:attributes) do
      {
        practice_id: 195_900,
        department_id: 1,
        start_date: '03/30/2016',
        end_date: '04/30/2016'
      }
    end

    it 'returns instance of PatientAppointmentCollection' do
      VCR.use_cassette('booked_appointments') do
        expect(client.booked_appointments(attributes))
          .to be_an_instance_of AthenaHealth::AppointmentCollection
      end
    end
  end

  describe '#find_appointment_type' do
    let(:attributes) do
      {
        practice_id: 195944,
        appointment_type_id: 2
      }
    end

    it 'returns instance of AppointmentType' do
      VCR.use_cassette('appointment_type') do
        expect(client.find_appointment_type(attributes))
          .to be_an_instance_of AthenaHealth::AppointmentType
      end
    end
  end

  describe '#appointment_notes' do
    let(:attributes) do
      {
        practice_id: 195_900,
        appointment_id: 665_874
      }
    end

    it 'returns instance of NoteCollection' do
      VCR.use_cassette('appointment_notes') do
        expect(client.appointment_notes(attributes))
          .to be_an_instance_of AthenaHealth::NoteCollection
      end
    end
  end

  describe 'create_appointment_note' do
    let(:attributes) do
      {
        practice_id: 195_900,
        appointment_id: 665_874,
        note_text: 'Sample note'
      }
    end

    it 'returns success => true' do
      VCR.use_cassette('create_appointment_note') do
        expect(client.create_appointment_note(attributes))
          .to eq 'success' => 'true'
      end
    end
  end
end
