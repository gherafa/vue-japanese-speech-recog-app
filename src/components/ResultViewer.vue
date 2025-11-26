<template>
  <div
    class="mt-6 p-6 rounded-3xl shadow-lg bg-white/70 backdrop-blur-md border border-gray-200 min-h-[200px] transition-all"
  >
    <div 
      v-if="isProcessingRecording"
      class="flex flex-col justify-center items-center space-y-4 py-8"
    >
      <div class="relative">
        <div class="absolute inset-0 rounded-full bg-blue-400 blur-xl opacity-40 animate-pulse"></div>
        <svg
          class="animate-spin h-20 w-20 text-blue-700 drop-shadow-lg relative"
          xmlns="http://www.w3.org/2000/svg"
          fill="none"
          viewBox="0 0 24 24"
        >
          <circle
            class="opacity-25"
            cx="12"
            cy="12"
            r="10"
            stroke="currentColor"
            stroke-width="4"
          ></circle>
          <path
            class="opacity-75"
            fill="currentColor"
            d="M4 12a8 8 0 018-8v4a4 4 0 00-4 4H4z"
          ></path>
        </svg>
      </div>

      <p class="text-gray-700 font-medium text-lg">
        Processing your recording...
      </p>
    </div>

    <div v-else class="space-y-6">
      <h3 class="text-2xl font-semibold text-gray-900">
        Speech Analysis Result
      </h3>

      <div class="flex items-center gap-3">
        <span class="text-lg font-medium text-gray-700">Score:</span>
        <span
          :class="[
            'text-2xl font-bold px-4 py-1 rounded-full shadow',
            scoreColor
          ]"
        >
          {{ pronounceResult.score ?? 0 }}
        </span>
      </div>

      <div>
        <h4 class="font-semibold text-gray-800">Your Pronunciation</h4>
        <p class="text-gray-700 leading-relaxed bg-gray-100 p-3 rounded-xl mt-1">
          <span v-html="highlightDiff(pronounceResult.reference_text, pronounceResult.spoken_text)"></span>
        </p>
      </div>


      <div>
        <h4 class="font-semibold text-gray-800">Reference Text</h4>
        <p class="text-gray-700 leading-relaxed bg-white p-3 rounded-xl mt-1 border border-gray-200">
          {{ pronounceResult.reference_text || "No reference text..." }}
        </p>
      </div>
    </div>
  </div>
</template>

<script setup>
  import { computed } from 'vue'
  const props = defineProps({
    pronounceResult: Object,
    isProcessingRecording: Boolean
  })

  const scoreColor = computed(() => {
    const s = props.pronounceResult.score || 0
    if (s > 85) return "bg-green-500 text-white"
    if (s > 60) return "bg-yellow-400 text-gray-900"
    return "bg-red-500 text-white"
  })

  function highlightDiff(reference = "", spoken = "") {
    if (!reference || !spoken) return spoken || ""

    let result = ""
    for (let i = 0; i < reference.length; i++) {
      const refChar = reference[i]
      const spokenChar = spoken[i]

      if (refChar !== spokenChar) {
        result += `<span class="text-red-500 font-bold">${spokenChar || "?"}</span>`
      } else {
        result += `<span>${spokenChar}</span>`
      }
    }
    return result
  }
</script>
