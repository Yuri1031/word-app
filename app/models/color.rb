class Color < ActiveHash::Base
  self.data = [
   { id: 1, name: '---' },
   { id: 2, name: '#DDC354' },
   { id: 3, name: '#EFA14C' },
   { id: 4, name: '#E18A6C' },
   { id: 5, name: '#E08081' },
   { id: 6, name: '#C48590' },
   { id: 7, name: '#A072A1' },
   { id: 8, name: '#6E709D' },
   { id: 9, name: '#4E74A1' },
   { id: 10, name: '#458CA8' },
   { id: 11, name: '#4DA497' },
   { id: 12, name: '#70B187' },
   { id: 13, name: '#A9C25C' }
 ]

  include ActiveHash::Associations
  has_many :users
end
