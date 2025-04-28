/**
 * 
 */
const tarotCards = [
  "The Fool - New beginnings, adventure",
  "The Magician - Manifestation, power",
  "The High Priestess - Intuition, secrets",
  "The Empress - Fertility, beauty",
  "The Emperor - Leadership, control",
  "The Lovers - Love, harmony",
  "The Chariot - Determination, success",
  "Death - Transformation, endings",
  "The Tower - Sudden change, upheaval",
  "The Star - Hope, inspiration"
];

const horoscopes = {
  aries: "Be bold today — take initiative and lead with confidence.",
  taurus: "Stability is your strength. Trust your instincts.",
  gemini: "Your curiosity will open new doors — explore and connect.",
  cancer: "Nurture your inner self. Emotions bring clarity today.",
  leo: "Let your light shine. Recognition is on the way.",
  virgo: "Attention to detail brings success. Stay focused.",
  libra: "Balance is key. Seek harmony in your relationships.",
  scorpio: "Dive deep. Transformation is near.",
  sagittarius: "Adventure calls. Say yes to something new.",
  capricorn: "Hard work pays off. Stay committed.",
  aquarius: "Innovate and dream big. Your ideas matter.",
  pisces: "Let your imagination flow. Artistic energy is strong."
};

function drawTarot() {
  const card = tarotCards[Math.floor(Math.random() * tarotCards.length)];
  document.getElementById('tarotResult').innerText = `✨ You drew: ${card}`;
}

function showHoroscope() {
  const sign = document.getElementById('zodiacInput').value.trim().toLowerCase();
  const message = horoscopes[sign];

  if (message) {
    document.getElementById('horoscopeResult').innerText = `🌟 Horoscope for ${sign.charAt(0).toUpperCase() + sign.slice(1)}:\n${message}`;
  } else {
    document.getElementById('horoscopeResult').innerText = "❗ Please enter a valid zodiac sign.";
  }
}
