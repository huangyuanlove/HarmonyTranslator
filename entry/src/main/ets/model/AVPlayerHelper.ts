import AVPlayer from '@ohos.multimedia.media'
import media from '@ohos.multimedia.media';
export class AVPlayerHelper {
  constructor() {


    media.createAVPlayer((error, video) => {

      if (video != null) {
        this.avPlayer = video;
        console.error(`createAVPlayer success `);
        this.setAVPlayerStateChange()
      } else {
        console.error(`createAVPlayer fail, error message:${error.message}`);
      }
    });
  }

  private avPlayer;
  setAVPlayerStateChange() {
    if (this.avPlayer != undefined) {
      this.avPlayer.on('stateChange', async (state, reason) => {
        switch (state) {
          case 'idle':
            console.error('state idle called')
            break;
          case 'initialized':
            console.error('initialized prepared called')
            this.avPlayer.prepare()
            break;
          case 'prepared':
            console.error('state prepared called')
            this.avPlayer.play()
            break;
          case 'playing':
            console.error('state playing called')
            break;
          case 'paused':
            console.error('state paused called')
            break;
          case 'completed':
            console.error('state completed called')
            this.avPlayer.reset()
            break;
          case 'stopped':
            console.error('state stopped called')
            break;
          case 'released':
            console.error('state released called')
            break;
          case 'error':
            console.error('state error called')
            this.avPlayer.reset()
            break;
          default:
            console.info('unkown state :' + state)
            break;
        }
      })
    }
  }

  playWithUrl(url:string){
    if(this.avPlayer){
      this.avPlayer.reset()
      this.avPlayer.url = url
    }
  }
  reset(){
    if(this.avPlayer){
      this.avPlayer.reset();
    }
  }


}