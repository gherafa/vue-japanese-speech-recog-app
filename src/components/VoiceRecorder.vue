<template>
  <div class="flex flex-col items-center gap-8">

    <div
      class="backdrop-blur-xl bg-white/20 border border-white/30 shadow-xl 
             rounded-3xl p-8 flex flex-col items-center gap-6 w-[280px]"
    >
      <div
        @click="toggleRecording"
        class="relative flex items-center justify-center cursor-pointer 
               transition active:scale-95"
      >
        <div 
          class="absolute inset-0 rounded-full"
          :class="isRecording ? 'recording-glow' : ''"
        ></div>

        <div 
          class="w-24 h-24 rounded-full flex items-center justify-center
                 transition shadow-lg"
          :class="isRecording 
            ? 'bg-red-600 text-white' 
            : 'bg-blue-600 text-white hover:bg-blue-700'"
        >
          <svg v-if="!isRecording" xmlns="http://www.w3.org/2000/svg" 
            class="w-10 h-10" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M12 1a3 3 0 013 3v6a3 3 0 01-6 0V4a3 3 0 013-3z"/>
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M19 10a7 7 0 01-14 0M12 17v6m-4 0h8"/>
          </svg>

          <svg v-else xmlns="http://www.w3.org/2000/svg" 
            class="w-10 h-10" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <rect x="6" y="6" width="12" height="12" rx="2" stroke-width="2"/>
          </svg>
        </div>
      </div>

      <div class="text-white text-lg font-medium drop-shadow">
        {{ isRecording ? "Recording... Analyzing..." : "Record to Practice" }}
      </div>
    </div>

    <div v-if="isRecording" class="flex items-end gap-1 h-12">
      <div v-for="n in 14" :key="n"
        class="w-1 bg-blue-300 rounded-full animate-wave"
        :style="{ animationDelay: `${n * 0.07}s` }"
      ></div>
    </div>

    <div v-if="isPending" class="text-white/80 text-sm flex items-center gap-2 animate-pulse">
      <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <circle cx="12" cy="12" r="10" stroke-width="2" class="opacity-25"/>
        <path stroke-width="2" d="M12 6v6l4 2" class="opacity-75"/>
      </svg>
      Processing...
    </div>

    <div v-if="isRecordingError" class="text-red-500 text-sm flex items-center gap-2">
      <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
      </svg>
      Error occurred during recording. Please try again.
    </div>

  </div>
</template>

<script setup>
import { ref, watchEffect, watch } from "vue"
import { useMutation } from "@tanstack/vue-query"
import { postAudio } from "../services/fastApiService"

let mediaRecorder
const audioChunks = []
const isRecording = ref(false)
const isRecordingError = ref(false)

const { mutate: sendAudio, isPending } = useMutation({
  mutationFn: (blob) => postAudio(blob, props.generatedText.practice_text),
  onSuccess: (data) => {
    props.onResult(data)
    props.setProcessingRecording(false)
  },
  onError: (err) => {
    console.error('Failed to transcribe audio:', err)
    isRecordingError.value = true
    props.setProcessingRecording(false)
  }
})

async function toggleRecording() {
  isRecordingError.value = false
  if (!isRecording.value) {
    const stream = await navigator.mediaDevices.getUserMedia({ audio: true })
    mediaRecorder = new MediaRecorder(stream)

    mediaRecorder.ondataavailable = (e) => audioChunks.push(e.data)
    mediaRecorder.onstop = () => {
      const audioBlob = new Blob(audioChunks, { type: "audio/webm" })
      audioChunks.length = 0
      sendAudio(audioBlob)
    }

    mediaRecorder.start()
    isRecording.value = true
  } else {
    mediaRecorder.stop()
    isRecording.value = false
  }
}

const props = defineProps({
  generatedText: String,
  onResult: Function,
  setProcessingRecording: Function
})

watch(isPending, (pending) => {
  if (pending) {
    props.setProcessingRecording(true)
  }
})

</script>
<style scoped>
@keyframes wave {
  0% { height: 5px; opacity: 0.4; }
  50% { height: 40px; opacity: 1; }
  100% { height: 5px; opacity: 0.4; }
}
.animate-wave {
  animation: wave 0.8s infinite ease-in-out;
}

@keyframes glowPulse {
  0%   { box-shadow: 0 0 10px rgba(255,0,0,0.4), 0 0 20px rgba(255,0,0,0.2); }
  50%  { box-shadow: 0 0 25px rgba(255,0,0,0.6), 0 0 45px rgba(255,0,0,0.4); }
  100% { box-shadow: 0 0 10px rgba(255,0,0,0.4), 0 0 20px rgba(255,0,0,0.2); }
}
.recording-glow {
  animation: glowPulse 1.5s infinite ease-in-out;
}
</style>