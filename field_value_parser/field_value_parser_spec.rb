require 'field_value_parser'

describe 'parser' do
  let(:values) { { text_1: 'text1_value [NUMBER_1]', number_1: '2' } }
  let(:values_2) { { text_1: 'text1_value [NUMBER_1]', text_2: 'text2_value [TEXT_1]', number_1: '2' } }
  let(:values_3) { { text_1: 'text1_value [NUMBER_1]', text_2: 'text2_value [TEXT_1]' } }
  let(:values_4) { { text_1: 'text1_value [TEXT_1]', text_2: 'text2_value [TEXT_1] [TEXT_2]' } }
  let(:values_5) { { text_1: 'text1_value [TEXT_2]', text_2: 'text2_value [TEXT_3] [TEXT_2]',
                     text_3: 'text3_value [TEXT_4]', text_4: 'text4_value' } }

  let(:values_6) { {text_1: 't1_value', text_2: 't2_value [TEXT_1]', text_3: 't3_value [TEXT_2]', text_4: 't4_value [TEXT_3]'} }
  let(:values_7) { {text_1: 't1_value [TEXT_2] [TEXT_3] [TEXT_4]', text_2: 't2_value [TEXT_3]', text_3: 't3_value [TEXT_4]', text_4: 't4_value'} }

  context 'parse one level data' do

    subject { process_values(values) }

    it 'process data' do
      expect(subject).to include( text_1: 'text1_value 2', number_1: '2')
    end
  end

  context 'few levels' do
    subject { process_values(values_2) }

    it 'process data' do
      expect(subject).to include( text_2: 'text2_value text1_value 2',
                                  text_1: 'text1_value 2',
                                  number_1: '2')
    end
  end

  context 'some data not found' do
    subject { process_values(values_3) }

    it 'process data' do
      expect(subject).to include( text_2: 'text2_value text1_value [NUMBER_1]', text_1: 'text1_value [NUMBER_1]')
    end
  end

  context 'reference for self' do
    subject { process_values(values_4) }

    it 'process data' do
      expect(subject).to include( text_2: 'text2_value text1_value [TEXT_1] [TEXT_2]', text_1: 'text1_value [TEXT_1]')
    end
  end

  context '3 level' do
    subject { process_values(values_5) }

    it 'process data' do
      expect(subject).to include( text_1: 'text1_value text2_value text3_value text4_value [TEXT_2]', text_2: 'text2_value text3_value text4_value [TEXT_2]',
                                  text_3: 'text3_value text4_value', text_4: 'text4_value')
    end
  end

  context 'few' do
    subject { process_values(values_6) }

    it 'process data' do
      expect(subject).to include(text_1: 't1_value', text_2: 't2_value t1_value', text_3: 't3_value t2_value t1_value', text_4: 't4_value t3_value t2_value t1_value')
    end
  end

  context 'few' do
    subject { process_values(values_7) }

    it 'process data' do
      expect(subject).to include(text_1: 't1_value t2_value t3_value t4_value t3_value t4_value t4_value', text_2: 't2_value t3_value t4_value', text_3: 't3_value t4_value', text_4: 't4_value')
    end
  end
end
