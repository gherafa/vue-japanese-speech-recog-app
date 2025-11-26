async function generateKanji(level: string) {
  const res = await fetch(`http://localhost:8000/generate_text?level=${level}`, {
    method: "GET"
  })

  if (!res.ok) throw new Error("Failed to generate kanji")

  return res.json()
}

async function postAudio(audioBlob: any, referenceText: string) {
  const form = new FormData()
  form.append("file", audioBlob, "recording.m4a")

  const res = await fetch(`http://localhost:8000/score_pronunciation?text=${encodeURIComponent(referenceText)}`, {
    method: "POST",
    body: form
  })

  if (!res.ok) throw new Error("Failed to send audio")

  return res.json()
}

export {
  postAudio,
  generateKanji
}
