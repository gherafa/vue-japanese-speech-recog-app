<template>
  <div class="min-h-screen w-full bg-gray-400 flex flex-col items-center py-8 px-4 md:px-0">
    <div class="bg-gray-50 dark:bg-gray-600 rounded-3xl shadow-xl w-full max-w-4xl p-6 md:p-12 flex flex-col gap-10">
      <h1 class="text-3xl md:text-4xl font-bold text-center text-gray-900 dark:text-white">
        Japanese Speech Recognition App
      </h1>

      <div class="flex justify-center">
        <DropdownLevel 
          :selectLevel="selectLevel" :selectedLevel="selectedLevel"
          :toggleDropdown="toggleDropdown" :isOpen="isOpen" />
      </div>
      <div class="flex justify-center">
        <button 
          @click="generateKanjiMutation(selectedLevel)"
          class="px-6 py-3 bg-blue-600 text-white rounded-lg shadow-lg hover:bg-blue-700 active:scale-95 transition-all flex items-center gap-2 disabled:opacity-50"
          :disabled="isPending"
        >
          <svg v-if="isPending" class="animate-spin h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v4a4 4 0 00-4 4H4z"></path>
          </svg>

          <span>{{ isPending ? 'Generating...' : 'Generate Kanji' }}</span>
        </button>
      </div>

      <p v-if="generateKanjiError" class="text-red-500 text-center font-medium">
        Failed to generate Kanji. Please try again.
      </p>
      <div class="mt-6 w-full max-w-4xl px-4 md:px-0 bg-white border rounded-xl shadow-sm min-h-[80px] flex flex-col items-center justify-center">
        <template v-if="isPending">
          <div class="w-full space-y-2">
            <div class="mx-5 h-4 bg-gray-300 rounded animate-pulse"></div>
            <div class="mx-5 h-4 bg-gray-300 rounded animate-pulse"></div>
            <div class="mx-5 h-4 bg-gray-300 rounded animate-pulse"></div>
          </div>
        </template>

        <template v-else-if="kanjiResult">
          <KanjiSection :kanjiResult="kanjiResult" class="w-full" />
        </template>

        <template v-else>
          <span class="text-gray-400">No Kanji generated yet.</span>
        </template>
      </div>

      <div class="w-full">
        <VoiceRecorder 
          :onResult="setPronounceResult" 
          :generatedText="kanjiResult"
          :setProcessingRecording="setProcessingRecording"
        />
      </div>
      
      <div class="bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-700 rounded-xl shadow p-6 md:p-8">
        <ResultViewer :pronounceResult="pronounceResult" :isProcessingRecording="isProcessingRecording" />
      </div>

    </div>
  </div>
</template>

<script setup>
  import { ref } from "vue"
  import { useMutation } from "@tanstack/vue-query"
  import VoiceRecorder from "../components/VoiceRecorder.vue"
  import ResultViewer from "../components/ResultViewer.vue"
  import KanjiSection from "../components/KanjiSection.vue"
  import DropdownLevel from "../components/DropdownLevel.vue"
  import { generateKanji } from "../services/fastApiService"

  const pronounceResult = ref("")
  const kanjiResult = ref("")
  const generateKanjiError = ref(false)
  const selectedLevel = ref('Select Level')
  const isOpen = ref(false)
  const isProcessingRecording = ref(false)

  function setPronounceResult(data) {
    pronounceResult.value = data
  }

  function selectLevel(level) {
    selectedLevel.value = level
    isOpen.value = false
  }

  function toggleDropdown() {
    isOpen.value = !isOpen.value
  }

  function setProcessingRecording(data) {
    isProcessingRecording.value = data
  }

  const { mutate: generateKanjiMutation, isPending } = useMutation({
    mutationFn: (level) => generateKanji(level),
    onSuccess: (data) => {
      kanjiResult.value = data
      generateKanjiError.value = false
    },
    onError: (err) => {
      console.error('Failed to generate Kanji:', err)
      generateKanjiError.value = true
    }
  })
</script>
